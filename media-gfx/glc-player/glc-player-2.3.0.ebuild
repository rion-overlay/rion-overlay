# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: glc-player-2.3.0.ebuild $

EAPI="4"

inherit qt4-r2

SRC_URI="mirror://sourceforge/${PN}/GLC_Player_src_${PV}.zip"

DESCRIPTION="Open Source 3D viewer used to view 3d models"
HOMEPAGE="http://www.glc-player.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=media-libs/glc-lib-2.2.0"

RDEPEND=${DEPEND}

S="${WORKDIR}"

src_prepare() {
	sed -e "/TARGET/s/glc_player/${PN}/" -e "/INCLUDEPATH/s/local\///" -i *.pro || die
}

src_install(){
	insinto /usr
	dobin ${PN}
}
