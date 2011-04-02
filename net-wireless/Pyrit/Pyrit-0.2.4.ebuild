# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="1"

inherit python distutils flag-o-matic

DESCRIPTION="GPU-accelerated attack against WPA-PSK authentication"
HOMEPAGE="http://pyrit.googlecode.com"
SRC_URI="http://pyrit.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
		sys-libs/zlib"
RDEPEND="${DEPEND}"

RESTRICT_PYTHON_ABIS="3*"
QA_EXECSTACK="usr/lib64/python2.6/site-packages/cpyrit/_cpyrit_cpu.so"

src_prepare() {
#	filter-flags 
	filter-ldflags -Wl,--as-needed -Wl,--sort-common --as-needed --sort-common
	python_copy_sources
	distutils_src_prepare
}
