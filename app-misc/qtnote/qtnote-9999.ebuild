# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qt4-r2 git-2

DESCRIPTION="Qt note-taking application compatible with tomboy"
HOMEPAGE="http://ri0n.github.io/QtNote/"
EGIT_REPO_URI="https://github.com/Ri0n/QtNote"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtgui"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 ${PN}.pro PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}
