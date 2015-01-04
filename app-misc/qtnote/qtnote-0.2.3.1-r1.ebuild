# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2

DESCRIPTION="Qt note-taking application compatible with tomboy"
HOMEPAGE="http://ri0n.github.io/QtNote/"
SRC_URI="https://github.com/Ri0n/QtNote/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui"
RDEPEND="${DEPEND}"

PATCHES=( "$FILESDIR/explicitly-link-x11.patch" )

pkg_setup() {
	S="${WORKDIR}/QtNote-${PV}"
}

src_configure() {
	eqmake4 ${PN}.pro PREFIX=${EPREFIX}/usr
}
