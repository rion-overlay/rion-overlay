# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7,3_1,3_2,3_3} )
inherit distutils-r1

DESCRIPTION="Python library and shell utilities to monitor filesystem events"
HOMEPAGE="https://github.com/gorakhargosh/watchdog"
SRC_URI="https://github.com/gorakhargosh/watchdog/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyyaml"
RDEPEND="${DEPEND}
	dev-python/pathtools
	dev-python/argh"
