# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python module for system storage configuration"
HOMEPAGE="
	https://github.com/storaged-project/blivet
	https://pypi.org/project/blivet/
"
SRC_URI="
	https://github.com/storaged-project/blivet/archive/refs/tags/${P}.tar.gz
"
S="${WORKDIR}/${PN}-${P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"

DEPEND="
	>=sys-block/parted-3.4
	sys-libs/libblockdev[introspection,escrow]
	dev-libs/libbytesize[python]
	dev-python/pyudev
	sys-fs/lvm2[dbus]
	sys-fs/multipath-tools
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

distutils_enable_tests unittest
