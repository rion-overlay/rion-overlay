# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON="2.4"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="DNS Benchmark Utility"
HOMEPAGE="http://namebench.googlecode.com/"
SRC_URI="http://namebench.googlecode.com/files/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk"

DEPEND=""

RDEPEND="${DEPEND}
		tk? ( =dev-lang/python-2*[tk?] )"

RESTRICT_PYTHON_ABIS="3*"

pkg_setup() {
	use tk && python_tkinter_exists
}
