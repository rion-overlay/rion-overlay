# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: turboprint-1.96-r3.ebuild 962 2008-01-23 22:09:03Z casta $

inherit eutils

IUSE="gtk"

MY_P="${P}-4"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Turboprint driver"
HOMEPAGE="http://www.turboprint.de"
SRC_URI="x86? ( ftp://ftp.zedonet.com/${MY_P}.tgz ) amd64? ( ftp://ftp.zedonet.com/${MY_P}.x86_64.tgz )"
RESTRICT="mirror"

SLOT="0"
LICENSE="turboprint"
KEYWORDS="~x86 ~amd64"

DEPEND=">=net-print/cups-1.2.0
	virtual/ghostscript
	gtk? ( =x11-libs/gtk+-1.2*
	=dev-libs/glib-1.2* )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if ! useq gtk; then
		rm bin/xtpconfig
		rm bin/xtpsetup
	fi

	sed -i -e 's:/usr/lib64/cups/filter:/usr/libexec/cups/filter:' \
		-e 's:/usr/lib/cups/filter:/usr/libexec/cups/filter:' system.cfg
	epatch "${FILESDIR}/install-static-root.patch"

	# A small tool to overide some libc calls within the static closed
	# binary during install
	cp "${FILESDIR}/libcOverride.c" .
}

src_compile() {
	# Very dirty hack to avoid sandbox breakout (will override fopen and
	# unlink)
	einfo "Compiling sandbox workaround library"
	gcc -D_GNU_SOURCE -fPIC -shared -o libcOverride.so libcOverride.c -ldl
}

src_install() {
	# This is the default root for install-static in RPM mode (use this install
	# mode to respect sandbox)

	export RPM_BUILD_ROOT="${D}"
	export RBR="${D}"

	./lib/install-static --rpm --language=en

	#################################################
	# Load some defaults and generate configuration #
	#################################################

	einfo "Generating default configuration"
	CUPS_FILTERS=$(cups-config --serverbin)/filter
	eval $(cat "${D}/etc/turboprint/system.cfg")
	# Write cfg files
	# system file
	echo > "${D}${TPPATH_CONFIG}"/system.cfg "TP_LANGUAGE=en
TP_CHARSET=${TP_CHARSET}
TP_INSTALLATIONSTATE=1
TP_CUPS=1
TPBIN_BROWSER=${TPBIN_BROWSER}
TPFILE_PRINTCAP=${TPFILE_PRINTCAP}
TPPATH_CONFIG=${TPPATH_CONFIG}
TPPATH_SHARE=${TPPATH_SHARE}
TPPATH_SPOOL=${TPPATH_SPOOL}
TPPATH_BIN=${TPPATH_BIN}
TPPATH_FILTERS=${TPPATH_FILTERS}
TPPATH_DOC=${TPPATH_DOC}
TPPATH_LOG=${TPPATH_LOG}
TPPATH_TEMP=${TPPATH_TEMP}
TPPATH_MAN=${TPPATH_MAN}
TPPATH_CUPSDRIVER=${TPPATH_CUPSDRIVER}
TPPATH_CUPSSETTINGS=${TPPATH_CUPSSETTINGS}
TPPATH_CUPSFILTER=${CUPS_FILTERS}
TPPATH_CUPSFILTER64=${CUPS_FILTERS}
TPOWN_SPOOLDIR=${TPOWN_SPOOLDIR}
TPMOD_SPOOLDIR=${TPMOD_SPOOLDIR}
TPOWN_SPOOLFILE=${TPOWN_SPOOLFILE}
TPMOD_SPOOLFILE=${TPMOD_SPOOLFILE}"

	# Printers configuration file
	echo -e "\n[Turboprint_Config_File]\n" > "${D}${TPPATH_CONFIG}/turboprint.cfg"

	# Default cfg with correct permissions
	fperms 644 "${TPPATH_CONFIG}/turboprint.cfg"
	fperms 644 "${TPPATH_CONFIG}/system.cfg"

	# Some path (!!! AFTER loading defaults !!!)
	TP_SHARE=/usr/share/turboprint
	TPPATH_SHARE="${D}${TP_SHARE}"
	TPPATH_CUPSDRIVER="${D}usr/share/cups/model"
	TPPATH_CUPSFILTER="${CUPS_FILTERS}"

	# Prepare log files with right owner

	einfo "Setting-up log files permissions"
	fowners lp:lp "${TPPATH_LOG}/turboprint_cups.log"
	fowners lp:lp "${TPPATH_LOG}/turboprint.log"
	fperms 640 "${TPPATH_LOG}/turboprint_cups.log"
	fperms 640 "${TPPATH_LOG}/turboprint.log"

	# Remove dump file (use to check the key). It needs to be regenerated
	# manually while installing the key file

	if [ -e "${D}${TP_SHARE}/dump/dj970aligncontrol.prn" ] ; then
		rm -r "${D}${TP_SHARE}/dump/dj970aligncontrol.prn"
	fi

	# Menu entries

	if useq gtk; then
		einfo "Generating menu entries"
		insinto /usr/share/applications
		cp "${FILESDIR}/xtpconfig.desktop.in" xtpconfig.desktop
		cp "${FILESDIR}/xtpsetup.desktop.in" xtpsetup.desktop
		sed -i -e "s,@SHARE@,${TP_SHARE},g" xtpconfig.desktop xtpsetup.desktop
		doins xtpconfig.desktop xtpsetup.desktop
	fi

	# Generating ppds

	einfo "Generating ppd files"
	dodir "${TP_SHARE}/ppd"
	# Those 2 commands break sandbox (static path in binary)
	# and want to read on wrong path (destination dirs and
	# not sandboxed path)
	# We use this dirty LD_PRELOAD hack to translate paths
	LD_PRELOAD="${WORKDIR}/${MY_P}/libcOverride.so":${LD_PRELOAD} \
		./bin/tpsetup --writeppdfiles "${TP_SHARE}/ppd/"
	einfo "Simlinking ppd files"
	dosym "${TP_SHARE}/ppd" /usr/share/cups/model/turboprint
	# Currently disable configuration upgrade better to run it manually if
	# needed after install since it has to be launched on running configuration
	# and not default one !
	#LD_PRELOAD=${WORKDIR}/${MY_P}/libcOverride.so:${LD_PRELOAD} \
	#	./bin/tpsetup --update

	# Link TP filters to cupsfilters path
	# Because TP PPDs look for filter in cups path

	einfo "Simlinking turboprint engine"
	for i in pstoturboprint rastertoturboprint
	do
		dosym "${TP_SHARE}/lib/$i" "$CUPS_FILTERS/$i"
	done

	# French doc does not exists, do a symlink not to break xtpsetup
	dosym "${TP_SHARE}/doc/html" "${TP_SHARE}/doc/html_fr"
}

pkg_postinst() {
	# if cupsd started, it needs to be restarted
	/etc/init.d/cupsd status &> /dev/null
	if [ $? -eq 0 ]; then
		einfo "Restarting CUPS printing system..."
		/etc/init.d/cupsd restart &> /dev/null
	fi

	einfo ""
	einfo "You may need to update your printer configuration"
	einfo "using \"tpsetup --update\" command"
	einfo "It will eventually prompt you for a remote cups root"
	einfo "password depending on your cups configuration"
	einfo ""
	einfo "To install your registration key"
	einfo "Use \"tpsetup --install turboprint.key\" manually"
	einfo ""
}
