# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="2"

MY_PN="cpyrit-opencl"
inherit eutils distutils

DESCRIPTION="Nvidia-OpenCL  module for Pyrit"
HOMEPAGE="http://pyrit.googlecode.com/"
SRC_URI="http://pyrit.googlecode.com/files/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-util/nvidia-cuda-toolkit-2.3
		=x11-drivers/nvidia-drivers-190.53
		dev-libs/openssl
		sys-libs/zlib"
RDEPEND="${DEPEND}
		~net-wireless/Pyrit-${PV}"

RESTRICT_PYTHON_ABIS="3*"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	sed -i -e '/CL_DEVICE_COMPILER_NOT_AVAILABLE/d' _cpyrit_opencl.c || die "sed failed"

	epatch "${FILESDIR}"/*.patch

	distutils_src_prepare
}
