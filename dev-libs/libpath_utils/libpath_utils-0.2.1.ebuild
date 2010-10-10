# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Path_utils library from sssd project"
HOMEPAGE="https://fedorahosted.org/sssd/"
SRC_URI="https://fedorahosted.org/released/ding-libs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test doc"

DEPEND="doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"
RDEPEND=""

src_install() {
	emake DESTDIR="${ED}" install || die
}
