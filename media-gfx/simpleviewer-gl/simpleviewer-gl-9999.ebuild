# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit subversion

DESCRIPTION=""
HOMEPAGE=""
ESVN_REPO_URI="https://simpleviewer.svn.sourceforge.net/svnroot/simpleviewer"
ESVN_PROJECT="${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	virtual/opengl
	media-libs/freeglut
	dev-libs/libconfig
	media-libs/giflib
	media-libs/freetype
	media-libs/imlib2
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff"
RDEPEND="${DEPEND}"

src_install() {
	dobin sviewgl
	dodoc config.example
}
