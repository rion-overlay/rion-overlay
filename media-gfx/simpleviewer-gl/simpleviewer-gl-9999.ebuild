# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils subversion

DESCRIPTION="Small and simple image viewer for Linux."
HOMEPAGE="http://sourceforge.net/projects/simpleviewer/"
ESVN_REPO_URI="https://simpleviewer.svn.sourceforge.net/svnroot/simpleviewer"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/libconfig
	media-libs/freeglut
	media-libs/freetype:2
	media-libs/giflib
	media-libs/imlib2
	virtual/jpeg
	media-libs/libpng
	media-libs/tiff
	virtual/opengl
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "/^ADD_DEFINITIONS/d" \
		-i CMakeLists.txt || die
}

src_install() {
	dobin "${WORKDIR}"/sviewgl

	dodoc config.example README
}
