# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fdo-mime rpm multilib

IUSE="gnome java"

BUILDID="9505"
UREVER="1.6.1"
MY_PV3="${PV}-${BUILDID}"
BASIS="ooobasis3.2"
MST="OOO320_m18"
FILEPATH="http://ftp.chg.ru/pub/OpenOffice-RU/${PV}/ru"

if [ "${ARCH}" = "amd64" ] ; then
	OOARCH="x86_64"
else
	OOARCH="i586"
fi

S="${WORKDIR}/ru/RPMS"
UP="ru/RPMS"
DESCRIPTION="OpenOffice productivity suite. Russian Professional Edition"

SRC_URI="amd64? ( ${FILEPATH}/OOo_${PV}_Linux_x86-64_install-rpm_ru_infra.tar.gz )
	x86? ( ${FILEPATH}/OOo_${PV}_Linux_x86_install-rpm_ru_infra.tar.gz )"

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
	x11-libs/libXinerama
	>=media-libs/freetype-2.1.10-r2"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PDEPEND="java? ( >=virtual/jre-1.5 )"

PROVIDE="virtual/ooo"
RESTRICT="strip binchecks"

QA_EXECSTACK="usr/$(get_libdir)/openoffice/basis3.2/program/*
	usr/$(get_libdir)/openoffice/ure/lib/*"
QA_TEXTRELS="usr/$(get_libdir)/openoffice/ure/lib/*"
#QA_PRESTRIPPED="usr/$(get_libdir)/openoffice/basis3.2/program/*
#	usr/$(get_libdir)/openoffice/basis3.2/program/python-core-2.6.1/lib/lib-dynload/*
#	usr/$(get_libdir)/openoffice/program/*
#	usr/$(get_libdir)/openoffice/ure/bin/*
#	usr/$(get_libdir)/openoffice/ure/lib/*"

RESTRICT="mirror"

src_unpack() {

	unpack ${A}

	for i in base binfilter calc core01 core02 core03 core04 core05 core06 core07 draw graphicfilter images impress math ooofonts ooolinguistic pyuno testtool writer xsltfilter ; do
		rpm_unpack "./${UP}/${BASIS}-${i}-${MY_PV3}.${OOARCH}.rpm"
	done

	for j in base calc draw impress math writer; do
		rpm_unpack "./${UP}/openoffice.org3-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

	rpm_unpack "./${UP}/openoffice.org3-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/openoffice.org-ure-${UREVER}-${BUILDID}.${OOARCH}.rpm"

	rpm_unpack "./${UP}/desktop-integration/openoffice.org3.2-freedesktop-menus-3.2-${BUILDID}.noarch.rpm"

	use gnome && rpm_unpack "./${UP}/${BASIS}-gnome-integration-${MY_PV3}.${OOARCH}.rpm"
#	use kde && rpm_unpack "./${UP}/${BASIS}-kde-integration-${MY_PV3}.${OOARCH}.rpm"
	use java && rpm_unpack "./${UP}/${BASIS}-javafilter-${MY_PV3}.${OOARCH}.rpm"

	# Unpack provided dictionaries, unless there is a better solution...
	rpm_unpack "./${UP}/openoffice.org3-dict-de-DE-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/openoffice.org3-dict-en-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/openoffice.org3-dict-ru-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/openoffice.org3-dict-uk-${MY_PV3}.${OOARCH}.rpm"

	# Lang files
	rpm_unpack "./${UP}/${BASIS}-ru-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/openoffice.org3-ru-${MY_PV3}.${OOARCH}.rpm"
	for j in base binfilter calc draw help impress math res writer; do
		rpm_unpack "./${UP}/${BASIS}-ru-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

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

	# Make sure the permissions are right
	fowners -R root:0 /

	# Install wrapper script
	newbin "${FILESDIR}/wrapper.in" ooffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}/usr/bin/ooffice" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/program/s${app} /usr/bin/oo${app}
	done

	dosym ${INSTDIR}/program/spadmin /usr/bin/ooffice-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	rm -f "${D}${INSTDIR}/basis-link" || die
	dosym ${INSTDIR}/basis3.2 ${INSTDIR}/basis-link

	# Change user install dir
	sed -i -e "s/.openoffice.org\/3/.ooo3/g" "${D}${INSTDIR}/program/bootstraprc" || die

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}${INSTDIR}/ure/bin/javaldx"

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
	elog " package instead. "
	elog
	elog " Dictionaries for english, german, russian and ukrainian are provided in "
	elog " /usr/$(get_libdir)/openoffice/share/extension/install "
	elog " Other dictionaries can be found at Suns extension site. "
	elog

}
