# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools

DESCRIPTION="library for some string essentials"
HOMEPAGE="http://libestr.adiscon.com"
SRC_URI="http://libestr.adiscon.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
	$(use_enable debug) || die
}
src_install() {
	emake DESTDIR="${D}" install || die
	find "${ED}"/usr/$(get_libdir) -name \*.la -delete
	dodoc ChangeLog
}
