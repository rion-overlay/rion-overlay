# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
BLIVET_REV=db6a3ea9bdecf4c0cc536b9cd4528316569d27fb
S="${WORKDIR}/${PN}-${BLIVET_REV}"

inherit distutils-r1

DESCRIPTION="Python module for system storage configuration"
HOMEPAGE="https://github.com/storaged-project/blivet-gui"
SRC_URI="https://github.com/storaged-project/blivet-gui/archive/${BLIVET_REV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-block/blivet
	dev-python/pid
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests unittest
