# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

LANGS="ru"

inherit cmake-utils

MY_PN="${PN/vacuum-/}"
MY_P="${PN}_${PV}_1.1.1"
DESCRIPTION="Spell checker for vacuum"
HOMEPAGE="http://code.google.com/p/vacuum-im"
SRC_URI="https://vacuum-plugins.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

RDEPEND="
	>=net-im/vacuum-1.1.0
	app-text/enchant
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# linguas
	local langs="none;"
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x};"
	done

	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DLANGS="${langs}"
	)

	cmake-utils_src_configure
}
