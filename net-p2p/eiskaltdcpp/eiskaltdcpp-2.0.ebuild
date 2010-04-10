# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

LANGS="en ru be"
inherit qt4-r2 cmake-utils

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
HOMEPAGE="http://eiskaltdc.googlecode.com/"
SRC_URI="http://${PN/pp/}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aspell"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-core:4
	x11-libs/qt-dbus:4
	dev-libs/openssl
	net-libs/libupnp
	dev-libs/boost
	aspell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {

	local LANG=""
	for LANG in ${LINGUAS};do
		for X in ${LANGS};do
			if [[ ${LANG} == ${X} ]]; then
				langs+="${X}"
			fi
		done
	done

	local mycmakeargs="-DFREE_SPACE_BAR_C=1 \
					-DFREE_SPACE_BAR=0 \
					$(cmake-utils_use aspell USE_ASPELL) \
					-Dlinguas=${langs}"
	cmake-utils_src_configure
}
