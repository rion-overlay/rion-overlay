# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

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
