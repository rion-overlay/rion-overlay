# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit subversion cmake-utils

DESCRIPTION="Small and simple image viewer for Linux."
HOMEPAGE="http://sourceforge.net/projects/simpleviewer/"
ESVN_REPO_URI="https://simpleviewer.svn.sourceforge.net/svnroot/simpleviewer"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	media-libs/freeglut
	virtual/opengl
	media-libs/freetype:2
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	media-libs/giflib
	media-libs/imlib2
	dev-libs/libconfig"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
}

src_prepare() {
	sed -e "/^ADD_DEFINITION/d" -i CMakeLists.txt
}

src_install() {
	dobin sviewgl
	dodoc config.example
}
