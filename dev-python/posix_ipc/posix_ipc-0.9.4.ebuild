# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )
DISTUTILS_IN_SOURCE_BUILD="1"

inherit distutils-r1

DESCRIPTION="POSIX IPC library for Python"
HOMEPAGE="http://semanchuk.com/philip/posix_ipc/"
SRC_URI="http://semanchuk.com/philip/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	distutils-r1_src_install
	dohtml *.html

	use examples && {
		insinto /usr/share/doc/${PF}/shm_example
		doins demo/{ReadMe.txt,{utils,premise,conclusion}.py}
		insinto /usr/share/doc/${PF}/mq_example
		doins demo2/{ReadMe.txt,{utils,premise,conclusion}.py}
	}
}
