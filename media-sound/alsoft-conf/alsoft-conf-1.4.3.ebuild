# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

WANT_CMAKE="always"
inherit cmake-utils

DESCRIPTION="OpenAL Soft Configurator"
HOMEPAGE="http://www.anduin.net/~angasule/"
SRC_URI="http://www.anduin.net/~angasule/fp-content/attachs/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
		dev-qt/qtgui:4"

RDEPEND="${DEPEND}"
