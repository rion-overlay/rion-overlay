# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="2"

inherit distutils

DESCRIPTION="AMD/ATI Stream  module for Pyrit"
HOMEPAGE="http://pyrit.googlecode.com/"
SRC_URI="http://pyrit.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
		sys-libs/zlib
		dev-util/ati-stream-sdk-bin"

RDEPEND="${DEPEND}
		~net-wireless/Pyrit-${PV}"

RESTRICT_PYTHON_ABIS="3*"

src_prepare() {
	sed -i -e 's/opt\/atibrook\/sdk/opt\/atibrook/' setup.py || die "sed failed"

	distutils_src_prepare
}
