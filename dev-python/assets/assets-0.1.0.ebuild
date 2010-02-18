# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_PYTHON="2.6"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Cache-friendly asset management via content-hash-naming"
HOMEPAGE="http://jderose.fedorapeople.org/assets"
SRC_URI="http://jderose.fedorapeople.org/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

DOCS="README TODO AUTHORS"

RESTRICT_PYTHON_ABIS="3.*"
python_enable_pyc
