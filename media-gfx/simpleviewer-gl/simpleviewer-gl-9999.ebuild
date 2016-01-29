# Copyright 1999-2016 Gentoo Foundation
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

src_install() {
	dobin "${BUILD_DIR}"/sviewgl

	dodoc config.example README
}
