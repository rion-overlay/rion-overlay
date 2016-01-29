# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER="2.8"

inherit wxwidgets

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://wxcode.sourceforge.net/components/wxsqlite3/"
SRC_URI="mirror://sourceforge/wxcode/wxsqlite3-${PV}.tar.gz"

LICENSE="wxWinLL-3.1"
SLOT="${WX_GTK_VER}"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	x11-libs/wxGTK:2.8[X]
	dev-db/sqlite:3[extensions(+)]
"
DEPEND="${RDEPEND}"

DOCS=( Readme.txt )

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-unicode \
		--enable-shared \
		--enable-metadata \
		--disable-codec \
		--enable-load_extension \
		--with-wx-config="${WX_CONFIG}" \
		--with-wxshared \
		--with-sqlite3-prefix="${EPREFIX}"/usr
}
