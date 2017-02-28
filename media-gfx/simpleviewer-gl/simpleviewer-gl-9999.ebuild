# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Small and simple image viewer for Linux."
HOMEPAGE="http://www.ugolnik.info/?p=1302"
EGIT_REPO_URI="https://bitbucket.org/andreyu/simple-viewer-gl"
EGIT_BRANCH=development

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sys-libs/zlib
	media-libs/glfw
	media-libs/freetype:2
	media-libs/giflib
	media-libs/imlib2[X,jpeg,gif,png,tiff]
	media-libs/libwebp
	media-libs/libexif
	media-libs/lcms
	virtual/jpeg:0
	media-libs/libpng:0
	media-libs/tiff:0
	virtual/opengl
"
RDEPEND="${DEPEND}"

src_install() {
	dobin "${BUILD_DIR}"/sviewgl

	dodoc config.example README.md
}
