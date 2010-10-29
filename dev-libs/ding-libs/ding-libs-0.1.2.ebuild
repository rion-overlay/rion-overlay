# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Library set needed for build sssd"
HOMEPAGE="https://fedorahosted.org/sssd"
SRC_URI="https://fedorahosted.org/released/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"

KEYWORDS="~amd64"
IUSE="test"

RDEPEND="!dev-libs/libcollection
	!dev-libs/libdhash
	!dev-libs/libini_config
	!dev-libs/libpath_utils
	!dev-libs/libref_array"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"

src_test() {
	emake check || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
