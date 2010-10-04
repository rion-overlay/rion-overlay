# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_CMAKE="always"
inherit cmake-utils

DESCRIPTION="OpenAL Soft Configurator"
HOMEPAGE="http://www.anduin.net/~angasule/"
SRC_URI="http://www.anduin.net/~angasule/fp-content/attachs/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core:4
		x11-libs/qt-gui:4"

RDEPEND="${DEPEND}"

src_install() {
	dobin "${CMAKE_BUILD_DIR}/${PN}"
}
