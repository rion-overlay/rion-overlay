# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Plugins for Geany"
HOMEPAGE="http://plugins.geany.org/geany-plugins/"
SRC_URI="http://plugins.geany.org/geany-plugins/${P}.tar.bz2"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lua gtkspell spell"

DEPEND=">=dev-util/geany-0.17
	lua? ( dev-lang/lua )
	gtkspell? ( app-text/gtkspell )
	spell? ( app-text/enchant )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable lua geanylua) \
		$(use_enable gtkspell) \
		$(use_enable spell spellcheck)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
