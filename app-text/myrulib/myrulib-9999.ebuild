# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
WX_GTK_VER="2.8"

inherit eutils wxwidgets git-2

DESCRIPTION="E-book collection manager"
HOMEPAGE="http://www.lintest.ru/wiki/MyRuLib"
EGIT_REPO_URI="git://github.com/lintest/myrulib"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+icu +links reader syslog"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	dev-libs/libxml2
	dev-db/sqlite:3[fts3(+),icu?]
	dev-db/wxsqlite3:${WX_GTK_VER}
	app-arch/bzip2
	icu? ( dev-libs/icu:= )
	reader? (
		media-libs/freetype:2
		media-libs/libpng:=
		virtual/jpeg
		sys-libs/zlib
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# for sure
	rm -rf \
		3rdparty/bzip2 \
		3rdparty/faxpp \
		3rdparty/sqlite3 \
		3rdparty/wxsqlite3 \
	|| die
}

src_configure() {
	econf \
		$(use_with icu) \
		$(use_with links) \
		$(use_with reader) \
		$(use_with syslog) \
		--without-bzip2 \
		--without-sqlite \
		--without-wxsqlite \
		--without-strip
}
