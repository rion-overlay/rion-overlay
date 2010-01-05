# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base

DESCRIPTION="TS/M2TS/BD video muxer/demuxer"
HOMEPAGE="http://www.smlabs.net/tsmuxer.html"
SRC_URI="http://www.smlabs.net/tsMuxer/${PN}_shared_${PV}.tar.gz"

LICENSE="SMLABS-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core:4
		amd64? ( >=app-emulation/emul-linux-x86-qtlibs-20081109 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	dobin "${S}/${PN}" || die "dobin ${PN} failed"
	dodoc readme.rus.txt
}
