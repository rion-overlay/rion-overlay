# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"
inherit apache-module autotools eutils
MY_P="${P/mod_/}"

SETIDMODES="mode-force mode-owner mode-paranoid"

DESCRIPTION="A PHP wrapper for Apache2"
HOMEPAGE="http://www.suphp.org/"
SRC_URI="http://www.suphp.org/download/"${MY_P}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="checkpath ${SETIDMODES}"

S="${WORKDIR}/${MY_P}"

APACHE2_MOD_CONF="70_${PN}"
APACHE2_MOD_DEFINE="SUPHP"

need_apache2_2
DEPEND=""
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_configure() {
	local myargs=""
	use checkpath || myargs="${myargs} --disable-checkpath"

	: ${SUPHP_MINUID:=1000}
	: ${SUPHP_MINGID:=100}
	: ${SUPHP_APACHEUSER:="apache"}
	: ${SUPHP_LOGFILE:="/var/log/apache2/suphp.log"}

	myargs="${myargs} \
			--with-setid-mode=${SUPHP_SETIDMODE} \
			--with-min-uid=${SUPHP_MINUID} \
			--with-min-gid=${SUPHP_MINGID} \
			--with-apache-user=${SUPHP_APACHEUSER} \
			--with-logfile=${SUPHP_LOGFILE} \
			--with-apxs=${APXS} \
			--with-apr=/usr/bin/apr-1-config"

	econf ${myargs} || die "econf failed"
}

src_compile() {
	eapi2_src_compile
}

src_install() {

	einstall || die
#	emake DESTDIR=$D install || die

	dodoc doc/apache/{CONFIG,INSTALL}
	newdoc doc/CONFIG CONFIG.other
	insinto /etc
	doins "$FILESDIR/suphp.conf"

	keepdir "${SUPHP_LOGFILE}"
}

pkg_postinst() {
	apache-module_pkg_postinst
}

pkg_setup() {

	modecnt=0

	for mode in "${SETIDMODES}" ; do
		if use "${mode}" ; then
			if [[ ${modecnt} -eq 0 ]] ; then
				SUPHP_SETIDMODE="${mode/mode-}"
				let modecnt++
			elif [[ ${modecnt} -ge 1 ]] ; then
				die "You can only select ONE mode in your USE flags!"
			fi
		fi
	done

	if [[ ${modecnt} -eq 0 ]] ; then
		ewarn
		ewarn "No mode selected, defaulting to paranoid!"
		ewarn
		ewarn "If you want to choose another mode, put mode-force OR mode-owner"
		ewarn "into your USE flags and run emerge again."
		ewarn
		SUPHP_SETIDMODE=paranoid
	fi

	elog
	elog "Using ${SUPHP_SETIDMODE/mode-} mode"
	elog
	elog "You can manipulate several configure options of this"
	elog "ebuild through environment variables:"
	elog
	elog "SUPHP_MINUID: Minimum UID, which is allowed to run scripts (default:1000)"
	elog "SUPHP_MINGID: Minimum GID, which is allowed to run scripts (default:100)"
	elog "SUPHP_APACHEUSER: Name of the user Apache is running as (default:apache)"
	elog "SUPHP_LOGFILE: Path to suPHP logfile (default:/var/log/apache2/suphp.log)"
	elog
#	elog "If you have store this setting, create file named $PN-$PV in directory"
#	elog "i.e $PORTAGE_CONFIGROOT/etc/portage/env.d/$CATEGORY/$PN-$PV"
#	elog "and store them eviroment variables"
#	elog "For more info,see man 5 portage and http://bugs.gentoo.org/show_bug.cgi?id=51061"
#	elog
	einfo "If you have .ht^ file support, plz install pecl-htscanner package"
}
