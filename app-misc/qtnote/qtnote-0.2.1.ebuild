# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2

DESCRIPTION="Qt note-taking application compatible with tomboy"
HOMEPAGE="http://code.google.com/p/qtnote"
SRC_URI="http://qtnote.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-libs/qt-gui"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 ${PN}.pro PREFIX=/usr
}
