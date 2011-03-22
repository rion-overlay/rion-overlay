# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools

DESCRIPTION="Libee - An Event Expression Library inspired by CEE"
HOMEPAGE="http://www.libee.org"
SRC_URI="http://www.libee.org/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/libxml2
	dev-libs/libestr"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) || die
}

src_compile() {
	emake -j1 || die
}

src_test() {
	emake -j1 check || die
}

src_install() {
	emake DESTDIR="${ED}" install || die
	find "${ED}"/usr/$(get_libdir) -name \*.la -delete
	dodoc INSTALL ChangeLog

}
