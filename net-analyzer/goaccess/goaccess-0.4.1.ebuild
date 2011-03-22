# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="A real-time Apache log analyzer and interactive viewer that runs in a terminal"
HOMEPAGE="http://goaccess.prosoftcorp.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip"

RDEPEND="
	sys-libs/ncurses
	dev-libs/glib:2
	geoip? ( dev-libs/geoip )
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_configure() {
	local myconf=""
	use geoip && myconf="--enable-geoip"

	econf \
		$myconf
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README TODO || die
}
