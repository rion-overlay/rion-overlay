# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Author: mva $

EAPI=2

LANGS="be en fr hu pl ru sr uk"
inherit qt4-r2 cmake-utils subversion

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
ESVN_REPO_URI="http://${PN%pp}.googlecode.com/svn/branches/trunk/"
HOMEPAGE="http://eiskaltdc.googlecode.com/"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE="javascript kde spell"

RDEPEND="x11-libs/qt-gui:4[dbus]
	app-arch/bzip2
	sys-libs/zlib
	dev-libs/openssl
	net-libs/libupnp
	dev-libs/boost
	virtual/libiconv
	javascript? ( x11-libs/qt-script )
	kde? ( kde-base/oxygen-icons )
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	# linguas
	local langs
	for lang in ${LANGS}; do
		use linguas_${lang} && langs+="${lang} "
	done
	[[ -z ${langs} ]] && langs=${LANGS}

	local mycmakeargs=(
		-DFREE_SPACE_BAR_C="1"
		"$(cmake-utils_use javascript USE_JS)"
		"$(cmake-utils_use kde USE_ICON_THEME)"
		"$(cmake-utils_use spell USE_ASPELL)"
		-Dlinguas="${langs}"
	)
	cmake-utils_src_configure
}
