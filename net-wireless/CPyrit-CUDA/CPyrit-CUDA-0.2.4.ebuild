# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
SUPPORT_PYTHON_ABIS="2"

inherit distutils

DESCRIPTION="Nvidia-CUDA module for Pyrit"
HOMEPAGE="http://pyrit.googlecode.com/"
SRC_URI="http://pyrit.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/nvidia-cuda-toolkit
		>=x11-drivers/nvidia-drivers-190"
RDEPEND="${DEPEND}"
RESTRICT_PYTHON_ABIS="3*"
