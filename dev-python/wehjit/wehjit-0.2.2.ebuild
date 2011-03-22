# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="A Python web-widget library"
HOMEPAGE="http://jderose.fedorapeople.org/wehjit"
SRC_URI="http://jderose.fedorapeople.org/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/nose
		dev-python/genshi
		dev-python/assets
		dev-python/paste
		dev-python/pygments
		"
RDEPEND="${DEPEND}"

DOCS="README TODO NEWS AUTHORS"

RESTRICT_PYTHON_ABIS="3.*"
python_enable_pyc
