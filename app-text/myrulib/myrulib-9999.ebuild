# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
WX_GTK_VER="2.8"

inherit eutils git

DESCRIPTION="Create your own collection of e-books"
HOMEPAGE="http://www.lintest.ru/wiki/MyRuLib"
EGIT_REPO_URI="git://github.com/lintest/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+stable"

if use stable; then
	EGIT_BRANCH="stable"
	EGIT_COMMIT="stable"
fi

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	>=dev-libs/expat-2
	dev-db/sqlite:3
	"
# TODO dev-db/wxSQLite3 (sunrise overlay)
DEPEND="${RDEPEND}"

src_prepare() {
	# for sure
	rm -rf \
		sources/Expat \
		sources/SQLite3 \
	|| die

	# fix upstream
	chmod +x configure
}

src_configure() {
	econf --without-strip
}

src_install() {
	emake DESTDIR="${D}" install || die
}
