# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="2"

inherit eutils distutils
#Sorru, only nvidia driver not stub 

DESCRIPTION="Nvidia-OpenCL  module for Pyrit"
HOMEPAGE="http://pyrit.googlecode.com/"
SRC_URI="http://pyrit.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/nvidia-cuda-toolkit
		~x11-drivers/nvidia-drivers-190.29
		dev-libs/openssl
		sys-libs/zlib"
RDEPEND="${DEPEND}
		~net-wireless/Pyrit-${PV}"

RESTRICT_PYTHON_ABIS="3*"

src_prepare() {
	sed -i -e '/CL_DEVICE_COMPILER_NOT_AVAILABLE/d' _cpyrit_opencl.c || die "sed failed"

	epatch "${FILESDIR}"/*.patch

	distutils_src_prepare
}
