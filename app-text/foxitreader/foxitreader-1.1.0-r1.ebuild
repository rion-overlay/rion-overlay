# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils fdo-mime versionator

MY_PN="FoxitReader"
MY_PV1=$(get_major_version)
MY_PV2=$(get_version_component_range 1-2)

DESCRIPTION="Free PDF document viewer for the Linux, featuring small size, quick startup, and fast page rendering"
HOMEPAGE="http://www.foxitsoftware.com/pdf/desklinux/"
IUSE="cups"

SRC_URI="http://mirrors.foxitsoftware.com/pub/foxit/reader/desktop/linux/${MY_PV1}.x/${MY_PV2}/enu/${MY_PN}-${PV}.tar.bz2"
LICENSE="EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="strip mirror"

# simple dependencies handling
DEPEND=""
RDEPEND="media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng
	x11-libs/pango
	x11-libs/cairo
	x11-base/xorg-server
	dev-libs/expat
	cups?	( net-print/cups )
	x86?	( >=x11-libs/gtk+-2.0 )
	amd64?	( app-emulation/emul-linux-x86-gtklibs )"

S="${WORKDIR}/${MY_PV2}-release"

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	has_multilib_profile && ABI="x86"
}

src_install() {
	dodir /opt/${PN}
	mv "${S}"/* "${D}"/opt/${PN}

	#a wrapper for that
	make_wrapper "${PN}" ./"${MY_PN}" /opt/"${PN}"
	newicon "${FILESDIR}/${PN}".png "${PN}".png
	newmenu "${FILESDIR}/${PN}".desktop "${PN}".desktop
	#make_desktop_entry ${PN} ${MY_PN} ${PN} "Application;Office;Viewer;"
}

pkg_postinst() {
	# Register new MIME types and activate file associations
	fdo-mime_mime_database_update
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	# Unregister MIME types and deactivate file associations
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
