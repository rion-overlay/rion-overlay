# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4-r2 eutils

DESCRIPTION="GUI front-end for tsMuxeR"
HOMEPAGE="http://www.smlabs.net/tsmuxer.html"
SRC_URI="http://www.smlabs.net/tsMuxer/${PN}_${PV}.src.zip"

LICENSE="SMLABS-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core:4
		x11-libs/qt-gui:4
		x11-libs/qt-phonon:4"
RDEPEND="${DEPEND}
		media-video/tsMuxeR"

S="$WORKDIR"

src_install() {
	dobin "${S}/${PN}" || die "dobin failed"
	newicon  "${S}"/images/icon.png "${PN}".png
	make_desktop_entry tsMuxerGUI  ${PN} "${PN}".png
}
