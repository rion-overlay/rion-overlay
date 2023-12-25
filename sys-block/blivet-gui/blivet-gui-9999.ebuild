# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 git-r3

DESCRIPTION="Python module for system storage configuration"
HOMEPAGE="
	https://github.com/storaged-project/blivet-gui
"
EGIT_REPO_URI="https://github.com/storaged-project/blivet-gui"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

DEPEND="
	sys-block/blivet
	dev-python/pid
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests unittest
