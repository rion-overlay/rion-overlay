# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

MY_PN="GLC_lib"

SRC_URI="mirror://sourceforge/${PN}/${MY_PN}_src_${PV}.zip"

DESCRIPTION="OpenGL Library Class"
HOMEPAGE="http://www.glc-lib.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-qt/qtopengl:4
	sys-libs/zlib
	virtual/glu"

RDEPEND="${DEPEND}"

S="${WORKDIR}/glc_lib"

src_prepare() {
	epatch	"${FILESDIR}/${PN}-2.1.0-install_path.patch" \
		"${FILESDIR}/${P}-depend_on_libGLU.patch" \
		"${FILESDIR}/${P}-fix_inline_shared_functions.patch"
}
