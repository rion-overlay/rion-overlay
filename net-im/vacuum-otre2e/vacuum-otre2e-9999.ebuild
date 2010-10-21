# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4-r2 subversion

MY_PN="${PN/vacuum-/}"
DESCRIPTION="Off-The-Record messaging (OTR) for vacuum"
HOMEPAGE="http://code.google.com/p/vacuum-plugins"
ESVN_REPO_URI="http://vacuum-plugins.googlecode.com/svn/plugins/${MY_PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

VACUUM_DEPEND=">=net-im/vacuum-1.0.3"
RDEPEND="
	${VACUUM_DEPEND}
	net-libs/libotr
"
DEPEND="${RDEPEND}
	${VACUUM_DEPEND}[sdk]
"

src_configure() {
	eqmake4 ${MY_PN}.pro \
		INSTALL_PREFIX="/usr" \
		INSTALL_APP_DIR="vacuum" \
		INSTALL_LIB_DIR="$(get_libdir)" \
		INSTALL_RES_DIR="share"
}
