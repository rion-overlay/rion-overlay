# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="OpenAL Soft Configurator"
HOMEPAGE="http://www.anduin.net/~angasule/"
SRC_URI="http://www.anduin.net/~angasule/fp-content/attachs/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="x11-libs/qt-gui"

src_install() {
	dobin "${CMAKE_BUILD_DIR}/${PN}"
}
