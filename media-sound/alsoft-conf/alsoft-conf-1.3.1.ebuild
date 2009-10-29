# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

MY_P="${PN}_${PV}"

DESCRIPTION="OpenAL Soft Configurator"
HOMEPAGE="http://www.anduin.net/~angasule/"
SRC_URI="http://www.anduin.net/~angasule/fp-content/attachs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x11-libs/qt-gui"

S="${WORKDIR}/${MY_P}"

src_install() {
	dobin "${CMAKE_BUILD_DIR}/${PN}"
}
