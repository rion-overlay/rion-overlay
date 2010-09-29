# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Collection library from sssd project"
HOMEPAGE="https://fedorahosted.org/sssd/"
SRC_URI="https://fedorahosted.org/released/ding-libs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc trace"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_configure() {
	econf $(use trace && echo '--enable-trace=7') || die
}

src_install() {
	emake DESTDIR="${ED}" install || die
}
