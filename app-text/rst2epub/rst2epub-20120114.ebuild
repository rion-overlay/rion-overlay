# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

HG_CHSET="c201bf292f3e"

DESCRIPTION="reStructuredText documents to epub files convertor"
HOMEPAGE="https://bitbucket.org/wierob/rst2epub/"
SRC_URI="https://bitbucket.org/wierob/${PN}/get/${HG_CHSET}.tar.bz2 ->
		${PN}-${HG_CHSET}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-python/docutils-0.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/wierob-${PN}-${HG_CHSET}"

src_prepare() {
	distutils_src_prepare
}
