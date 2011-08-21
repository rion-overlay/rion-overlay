# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

CMAKE_MIN_VERSION="2.6"

inherit cmake-utils

DESCRIPTION="System Information Gatherer And Reporter"
HOMEPAGE="http://support.hyperic.com/display/SIGAR"
SRC_URI="http://rion-overlay.googlecode.com/files/sigar-1.6.5-833ca18.tbz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"
DEPEND=""
RDEPEND=""

src_install() {
	cmake-utils_src_install
	dodoc README
}
