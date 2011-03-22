# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

LANGS="ru"

inherit qt4-r2 mercurial

MY_PN="${PN/vacuum-/}"
DESCRIPTION="Kinetic popup notifications for vacuum"
HOMEPAGE="http://code.google.com/p/vacuum-im"
EHG_REPO_URI="https://${MY_PN}.vacuum-plugins.googlecode.com/hg/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

VACUUM_DEPEND=">=net-im/vacuum-1.1.0"
RDEPEND="
	${VACUUM_DEPEND}
	x11-libs/qt-webkit:4
"
DEPEND="${RDEPEND}
	${VACUUM_DEPEND}[sdk]
"

S="${WORKDIR}/hg"

src_prepare() {
	qt4-r2_src_prepare

	# linguas
	for x in ${LANGS}; do
		if use !linguas_${x}; then
			rm -rf "translations/${x}/" || die
			sed -e "s#translations/${x}/\$\${FIRST_TARGET}.ts##" \
				-e "/TRANS_LANGS/s/${x}//" \
				-i translations.inc || die
		fi
	done
}

src_configure() {
	eqmake4 ${MY_PN}.pro \
		INSTALL_PREFIX="/usr" \
		INSTALL_APP_DIR="vacuum" \
		INSTALL_LIB_DIR="$(get_libdir)" \
		INSTALL_RES_DIR="share"
}
