# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )
inherit distutils-r1

REV_0_1_1=06d2c7d6c82c8c6fbd66e3202d7e4d1caa07d2ca
DESCRIPTION="Pattern matching and various utilities for file systems paths."
HOMEPAGE="https://github.com/gorakhargosh/pathtools"
SRC_URI="https://github.com/gorakhargosh/pathtools/archive/${REV_0_1_1}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${REV_0_1_1}"
