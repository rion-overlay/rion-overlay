# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2:2.5:2.6"

inherit distutils

DESCRIPTION="GoogleCL brings Google services to the command line"
HOMEPAGE="http://code.google.com/p/googlecl/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/gdata"
RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	doman man/*.1 || die
	dodoc changelog INSTALL.txt || die

	distutils_src_install
}
