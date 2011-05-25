# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.4"

inherit distutils

DESCRIPTION="POSIX IPC library for Python"
HOMEPAGE="http://semanchuk.com/philip/posix_ipc/"
SRC_URI="http://semanchuk.com/philip/posix_ipc/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	distutils_src_install
	dohtml *.html
	dodoc README

	use examples && {
		insinto /usr/share/doc/${PF}/shm_example
		doins demo/{ReadMe.txt,{utils,premise,conclusion}.py}
		insinto /usr/share/doc/${PF}/mq_example
		doins demo2/{ReadMe.txt,{utils,premise,conclusion}.py}
		}
}
