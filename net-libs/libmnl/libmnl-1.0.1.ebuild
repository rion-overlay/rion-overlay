# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools multilib

DESCRIPTION="Minimalistic nelink library"
HOMEPAGE="http://netfilter.org/projects/libmnl"
SRC_URI="http://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEN=""
RDEPEND="${DEPEND}"

src_prepare(){
	eautoreconf
}

src_test() {
	emake check || die
}

src_install() {
	emake DESTDIR="${ED}" install || die
	dodoc README

	if use examples; then
		insinto /usr/share/doc/${P}/examples
		doins -r "${S}/"examples/*
	fi
	# Remove unnedeed la files
	find "${ED}"/usr/$(get_libdir) -name \*.la -delete
}
