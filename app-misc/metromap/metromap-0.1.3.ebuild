# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Metromap is simple pygtk+2 programm for finding paths in metro(subway) maps."
HOMEPAGE="http://metromap.antex.ru/"
SRC_URI="http://metromap.antex.ru/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.8"
DEPEND="${RDEPEND}
	virtual/libiconv"

src_prepare() {
	iconv -f koi8-r -t utf8 metromap.desktop -o metromap.desktop || die
}

src_install() {
	emake DESTDIR="${D}"/usr install || die "emake install failed!"
}
