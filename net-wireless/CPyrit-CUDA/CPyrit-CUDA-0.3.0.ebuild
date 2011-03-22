# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="2"
MY_PN="cpyrit-cuda"
inherit distutils

DESCRIPTION="Nvidia-CUDA module for Pyrit"
HOMEPAGE="http://pyrit.googlecode.com/"
SRC_URI="http://pyrit.googlecode.com/files/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sse sse2"

DEPEND="sys-libs/zlib
		dev-libs/openssl
		dev-util/nvidia-cuda-toolkit
		>=x11-drivers/nvidia-drivers-190"
RDEPEND="${DEPEND}
		~net-wireless/Pyrit-${PV}"

RESTRICT_PYTHON_ABIS="3*"

S="${WORKDIR}/${MY_PN}-${PV}"
