# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.4"

MY_P=${PN/-/_}-${PV}

inherit distutils

DESCRIPTION="POSIX IPC library for Python"
HOMEPAGE="http://semanchuk.com/philip/posix_ipc/"
SRC_URI="http://semanchuk.com/philip/posix_ipc/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	distutils_src_install
	dohtml *.html
}
