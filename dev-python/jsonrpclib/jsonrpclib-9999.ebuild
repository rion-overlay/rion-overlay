# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils git

DESCRIPTION="Pure Python JSON-RPC 2.0 implementation"
HOMEPAGE="https://github.com/joshmarshall/jsonrpclib"
EGIT_REPO_URI="git://github.com/joshmarshall/jsonrpclib.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/simplejson"

