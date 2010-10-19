# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit subversion

DESCRIPTION="Small and simple image viewer for Linux."
HOMEPAGE="http://sourceforge.net/projects/simpleviewer/"
ESVN_REPO_URI="https://simpleviewer.svn.sourceforge.net/svnroot/simpleviewer"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	virtual/opengl
	media-libs/freeglut
	dev-libs/libconfig
	media-libs/giflib
	media-libs/freetype:2
	media-libs/imlib2
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed \
		-e "/^CC=/s/g++/$(tc-getCC)/"  \
		-e "/^CFLAGS=/s/-O2/${CFLAGS}/"  \
		-e "/^LDFLAGS=/s/$/ ${LDFLAGS}/"  \
		-e "/^LDFLAGS=/s/-s//"  \
		-i Makefile || die
}

src_install() {
	dobin sviewgl
	dodoc config.example
}
