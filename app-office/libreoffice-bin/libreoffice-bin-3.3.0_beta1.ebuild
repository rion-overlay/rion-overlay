# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils fdo-mime rpm multilib

IUSE="gnome java"

BUILDID="9526"
UREVER="1.7.0"
MY_PV="${PV/_*/}"
MY_PV1="${PV/_/-}"
MY_PV3="${MY_PV}-${BUILDID}"
BASIS="lobasis3.3"
FILEPATH="http://download.documentfoundation.org/libreoffice/testing"

if [ "${ARCH}" = "amd64" ] ; then
	OOARCH="x86_64"
else
	OOARCH="i586"
fi

S="${WORKDIR}/en-US/RPMS"
UP="en-US/RPMS"
DESCRIPTION="LibreOffice productivity suite."

SRC_URI="amd64? ( ${FILEPATH}/LO_${MY_PV1}_Linux_x86-64_install-rpm_en-US.tar.gz )
	x86? ( ${FILEPATH}/LO_${MY_PV1}_Linux_x86_install-rpm_en-US.tar.gz )"

HOMEPAGE="http://i-rs.ru/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!app-office/openoffice
	!app-office/openoffice-bin
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

QA_EXECSTACK="usr/$(get_libdir)/libreoffice/basis3.3/program/*
	usr/$(get_libdir)/libreoffice/ure/lib/*"
QA_TEXTRELS="usr/$(get_libdir)/libreoffice/ure/lib/*"
QA_PRESTRIPPED="usr/$(get_libdir)/libreoffice/basis3.3/program/*
	usr/$(get_libdir)/libreoffice/basis3.3/program/python-core-2.6.1/lib/lib-dynload/*
	usr/$(get_libdir)/libreoffice/program/*
	usr/$(get_libdir)/libreoffice/ure/bin/*
	usr/$(get_libdir)/libreoffice/ure/lib/*"

RESTRICT="mirror"

src_unpack() {

	unpack ${A}

	for i in base binfilter calc core01 core02 core03 core04 core05 core06 \
		core07 draw graphicfilter images impress math ogltrans ooofonts \
		ooolinguistic pyuno testtool writer xsltfilter ; do
		rpm_unpack "./${UP}/${BASIS}-${i}-${MY_PV3}.${OOARCH}.rpm"
	done

	for j in base calc draw impress math writer; do
		rpm_unpack "./${UP}/libreoffice3-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

	rpm_unpack "./${UP}/libreoffice3-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/libreoffice-ure-${UREVER}-${BUILDID}.${OOARCH}.rpm"

	rpm_unpack "./${UP}/desktop-integration/libreoffice3.3-freedesktop-menus-3.3-${BUILDID}.noarch.rpm"

	use gnome && rpm_unpack "./${UP}/${BASIS}-gnome-integration-${MY_PV3}.${OOARCH}.rpm"
	use kde && rpm_unpack "./${UP}/${BASIS}-kde-integration-${MY_PV3}.${OOARCH}.rpm"
	use java && rpm_unpack "./${UP}/${BASIS}-javafilter-${MY_PV3}.${OOARCH}.rpm"

	# Extensions
	for j in mediawiki-publisher pdf-import presentation-minimizer presenter-screen report-builder; do
		rpm_unpack "./${UP}/${BASIS}-extension-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

	# Lang files
	rpm_unpack "./${UP}/${BASIS}-en-US-${MY_PV3}.${OOARCH}.rpm"
	rpm_unpack "./${UP}/libreoffice3-en-US-${MY_PV3}.${OOARCH}.rpm"
	for j in base binfilter calc draw help impress math res writer; do
		rpm_unpack "./${UP}/${BASIS}-en-US-${j}-${MY_PV3}.${OOARCH}.rpm"
	done

}

src_install () {

	INSTDIR="/usr/$(get_libdir)/libreoffice"

	einfo "Installing OpenOffice.org into build root..."
	dodir ${INSTDIR}
	mv "${WORKDIR}"/opt/libreoffice3/* "${D}${INSTDIR}" || die

	#Menu entries, icons and mime-types
	cd "${D}${INSTDIR}/share/xdg/"

	for desk in base calc draw impress javafilter math printeradmin qstart startcenter writer; do
		if [ "${desk}" = "javafilter" ] ; then
			use java || { rm javafilter.desktop; continue; }
		fi
		mv ${desk}.desktop libreoffice-${desk}.desktop
		sed -i -e s/Exec=libreoffice/Exec=loffice/g libreoffice-${desk}.desktop || die
	#	sed -i -e s/openofficeorg3-${desk}/ooo-${desk}/g libreoffice-${desk}.desktop || die
		domenu libreoffice-${desk}.desktop
#		insinto /usr/share/pixmaps
#		if [ "${desk}" != "qstart" ] ; then
#			newins "${WORKDIR}/usr/share/icons/gnome/48x48/apps/openofficeorg3-${desk}.png" ooo-${desk}.png
#		fi
	done
	insinto /usr/share
	doins -r "${WORKDIR}"/usr/share/icons
	doins -r "${WORKDIR}"/usr/share/mime

	# Make sure the permissions are right
	fowners -R root:0 /

	# Install wrapper script
	newbin "${FILESDIR}/wrapper.in" loffice
	sed -i -e s/LIBDIR/$(get_libdir)/g "${D}/usr/bin/loffice" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/program/s${app} /usr/bin/lo${app}
	done

	dosym ${INSTDIR}/program/spadmin /usr/bin/loffice-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	rm -f "${D}${INSTDIR}/basis-link" || die
	dosym ${INSTDIR}/basis3.3 ${INSTDIR}/basis-link

	# Change user install dir
	sed -i -e "s/.libreoffice\/3/.lo3/g" "${D}${INSTDIR}/program/bootstraprc" || die

	# Non-java weirdness see bug #99366
	use !java && rm -f "${D}${INSTDIR}/ure/bin/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${FILESDIR}/50-libreoffice-bin"

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	[[ -x /sbin/chpax ]] && [[ -e /usr/$(get_libdir)/libreoffice/program/soffice.bin ]] && chpax -zm /usr/$(get_libdir)/libreoffice/program/soffice.bin

	elog " libreoffice-bin does not provide integration with system spell "
	elog " dictionaries. Please install them manually through the Extensions "
	elog " Manager (Tools > Extensions Manager) or use the source based "
	elog " package instead. "
	elog

}
