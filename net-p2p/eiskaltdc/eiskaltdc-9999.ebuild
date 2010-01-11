# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils qt4 subversion fdo-mime

DESCRIPTION="Qt based client for DirectConnect, fork of Valknut"
HOMEPAGE="https://sourceforge.net/projects/eiskaltdc/"
SRC_URI=""
KEYWORDS=""
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/qt-gui:4
	>=dev-libs/libxml2-2.4.22
	dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	cmake-utils_src_configure
}
src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README NEWS TODO
}
pkg_postinst() {
	fdo-mime_mime_database_update
}
pkg_postrm() {
	fdo-mime_mime_database_update
}
