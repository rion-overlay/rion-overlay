# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-r3

DESCRIPTION="Small and simple image viewer for Linux."
HOMEPAGE="http://sourceforge.net/projects/simpleviewer/"
EGIT_REPO_URI="https://bitbucket.org/andreyu/simple-viewer-gl"

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

CMAKE_USE_DIR="${S}/projects/linux"

src_prepare() {
	sed \
		-e "/^ADD_DEFINITIONS/d" \
		-i projects/linux/CMakeLists.txt || die
}

src_install() {
	dobin "${WORKDIR}"/sviewgl

	dodoc config.example README
}
