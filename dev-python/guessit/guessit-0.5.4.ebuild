# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python{2_6,2_7,3_2} )

inherit distutils-r1

DESCRIPTION="Python library that tries to extract as much information as possible from a filename"
HOMEPAGE="http://guessit.readthedocs.org/"
SRC_URI="https://github.com/wackou/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_test() {
	local i
	for i in tests/test_*.py; do
		"${PYTHON}" "${i}" || die "Tests fail with ${EPYTHON}"
	done
}
