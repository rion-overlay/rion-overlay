# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4-r2 mercurial

MY_PN="${PN/vacuum-/}"
DESCRIPTION="Kinetic popup notifications for vacuum"
HOMEPAGE="http://code.google.com/p/vacuum-im"
EHG_REPO_URI="https://${MY_PN}.vacuum-plugins.googlecode.com/hg/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

VACUUM_DEPEND=">=net-im/vacuum-1.0.3"
RDEPEND="
	${VACUUM_DEPEND}
	x11-libs/qt-webkit:4
"
DEPEND="${RDEPEND}
	${VACUUM_DEPEND}[sdk]
"

S="${WORKDIR}/hg"

src_configure() {
	eqmake4 ${MY_PN}.pro \
		INSTALL_PREFIX="/usr" \
		INSTALL_APP_DIR="vacuum" \
		INSTALL_LIB_DIR="$(get_libdir)" \
		INSTALL_RES_DIR="share"
}
