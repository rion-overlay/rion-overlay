# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )
inherit distutils-r1 git-r3

DESCRIPTION="Python library and shell utilities to monitor filesystem events"
HOMEPAGE="https://github.com/gorakhargosh/watchdog"
EGIT_REPO_URI="https://github.com/gorakhargosh/watchdog"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/pyyaml"
RDEPEND="${DEPEND}
	dev-python/pathtools
	dev-python/argh"
