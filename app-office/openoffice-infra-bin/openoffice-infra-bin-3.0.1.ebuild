# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openoffice-bin/openoffice-bin-3.0.0.ebuild,v 1.2 2008/10/17 20:30:41 maekke Exp $

inherit eutils fdo-mime rpm multilib

IUSE="gnome java kde"

BUILDID="9379"
UREVER="1.4.1"
MY_PV="${PV}rc2"
MY_PV3="${PV}-${BUILDID}"
BASIS="ooobasis3.0"
MST="OOO300_m9"

if [ "${ARCH}" = "amd64" ] ; then
	OOARCH="x86_64"
else
	OOARCH="i586"
fi

S="${WORKDIR}/ru/RPMS"
DESCRIPTION="OpenOffice productivity suite. Russian Professional Edition"

SRC_URI="amd64? ( http://download.i-rs.ru/pub/openoffice/${PV}/ru/OOo_${PV}_LinuxX86-64_install_ru_infra.tar.gz )
	x86? ( http://download.i-rs.ru/pub/openoffice/${PV}/ru/OOo_${PV}_LinuxIntel_install_ru_infra.tar.gz )"

HOMEPAGE="http://i-rs.ru/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!app-office/openoffice
	x11-libs/libXaw
	sys-libs/glibc
	>=dev-lang/perl-5.0
	app-arch/zip
	app-arch/unzip
	>=media-libs/freetype-2.1.10-r2
	java? ( >=virtual/jre-1.5 )"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PROVIDE="virtual/ooo"
RESTRICT="strip"

QA_EXECSTACK="usr/$(get_libdir)/openoffice/basis3.0/program/*"
QA_TEXTRELS="usr/$(get_libdir)/openoffice/basis3.0/program/libvclplug_genli.so \
	usr/$(get_libdir)/openoffice/basis3.0/program/python-core-2.3.4/lib/lib-dynload/_curses_panel.so \
	usr/$(get_libdir)/openoffice/basis3.0/program/python-core-2.3.4/lib/lib-dynload/_curses.so \
	usr/$(get_libdir)/openoffice/ure/lib/*"

RESTRICT="mirror"

src_unpack() {

	unpack ${A}

	for i in base binfilter calc core01 core02 core03 core04 core05 core06 core07 draw graphicfilter images impress math ooofonts ooolinguistic pyuno testtool writer xsltfilter ; do
		rpm_unpack "${S}/${BASIS}-${i}-${MY_PV3}.${OOARCH}.rpm"
	done

	for j in base calc draw impress math writer; do
		rpm_unpack "${S}/openoffice.org3-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

	rpm_unpack "${S}/openoffice.org3-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "${S}/openoffice.org-ure-${UREVER}-${BUILDID}.${OOARCH}.rpm"

	rpm_unpack "${S}/desktop-integration/openoffice.org3.0-freedesktop-menus-3.0-${BUILDID}.noarch.rpm"

	# Lang files
	rpm_unpack "${S}/${BASIS}-ru-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "${S}/openoffice.org3-ru-${MY_PV3}.${OOARCH}.rpm"
	for j in base binfilter calc draw help impress math res writer; do
		rpm_unpack "${S}/${BASIS}-ru-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

	for l in ${LINGUAS}; do
		rpm_unpack "${S}/openoffice.org3-dict-${l}-${MY_PV3}.${OOARCH}.rpm"
	done

	use gnome && rpm_unpack "${S}/${BASIS}-gnome-integration-${MY_PV3}.${OOARCH}.rpm"
	use kde && rpm_unpack "${S}/${BASIS}-kde-integration-${MY_PV3}.${OOARCH}.rpm"
	use java && rpm_unpack "${S}/${BASIS}-javafilter-${MY_PV3}.${OOARCH}.rpm"

}

src_install () {

	INSTDIR="/usr/$(get_libdir)/openoffice"

	einfo "Installing OpenOffice.org into build root..."
	dodir ${INSTDIR}
	mv "${WORKDIR}"/opt/openoffice.org/* "${D}${INSTDIR}" || die
	mv "${WORKDIR}"/opt/openoffice.org3/* "${D}${INSTDIR}" || die

	#Menu entries, icons and mime-types
	cd "${D}${INSTDIR}/share/xdg/"

	for desk in base calc draw impress math printeradmin qstart writer; do
		mv ${desk}.desktop openoffice.org-${desk}.desktop
		sed -i -e s/openoffice.org3/ooffice/g openoffice.org-${desk}.desktop || die
		sed -i -e s/openofficeorg3-${desk}/ooo-${desk}/g openoffice.org-${desk}.desktop || die
		domenu openoffice.org-${desk}.desktop
		insinto /usr/share/pixmaps
		if [ "${desk}" != "qstart" ] ; then
			newins "${WORKDIR}/usr/share/icons/gnome/48x48/apps/openofficeorg3-${desk}.png" ooo-${desk}.png
		fi
	done

	# Install wrapper script
	newbin "${FILESDIR}/wrapper.in" ooffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}/usr/bin/ooffice" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/program/s${app} /usr/bin/oo${app}
	done

	dosym ${INSTDIR}/program/spadmin /usr/bin/ooffice-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	#rm -f ${INSTDIR}/basis-link || die
	dosym ${INSTDIR}/basis3.0 ${INSTDIR}/basis-link

	# Change user install dir
	sed -i -e "s/.openoffice.org\/3/.ooo3/g" "${D}${INSTDIR}/program/bootstraprc" || die

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}${INSTDIR}/program/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/50-openoffice-bin"

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/openoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/openoffice/program/soffice.bin

	elog " openoffice-bin does not provide integration with system spell "
	elog " dictionaries. Please install them manually through the Extensions "
	elog " Manager (Tools > Extensions Manager) or use the source based "
	elog " package instead. Dictionary extensions installed to"
	elog "/usr//$(get_libdir)/openoffice/share/extension/install/ Use extensions"
	elog "manager to install them for your user"
	elog

	ewarn " Please note that this release of OpenOffice.org uses a "
	ewarn " new user install dir. As a result you will have to redo "
	ewarn " your settings. Alternatively you might copy the old one "
	ewarn " over from ~/.ooo-2.0 to ~/.ooo3, but be warned that this "
	ewarn " might break stuff. "
	ewarn

}
