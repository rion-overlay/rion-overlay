# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
WX_GTK_VER="2.8"

inherit eutils wxwidgets git

DESCRIPTION="E-book collection manager"
HOMEPAGE="http://www.lintest.ru/wiki/MyRuLib"
EGIT_REPO_URI="git://github.com/lintest/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	>=dev-libs/faxpp-0.4
	dev-db/sqlite:3[fts3]
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	# for sure
	rm -rf \
		3rdparty/sqlite3 \
	|| die
	# TODO 3rdparty/faxpp
}

src_configure() {
	econf --without-strip
}
