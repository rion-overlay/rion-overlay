# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit distutils

DESCRIPTION="IPy are a Python class and tools for handling of IPv4 and IPv6
addresses"
HOMEPAGE="https://github.com/haypo/python-ipy"
SRC_URI="http://github.com/haypo/python-ipy/zipball/IPy-0.75 -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
S=${WORKDIR}/haypo-python-ipy-614332d
