# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Azoth, the modular IM client for LeechCraft."

IUSE="debug +acetamide +autopaste +chathistory +depester +embedmedia
		+herbicide +hili +juick +nativeemoticons +p100q +rosenthal
		+standardstyles +xoox +xtazy"
BASICDEPEND="=net-misc/leechcraft-core-${PV}
		>=x11-libs/qt-webkit-4.6.0
		>=x11-libs/qt-multimedia-4.6.0
		xoox? ( =net-libs/qxmpp-0.3.44.1-r1[extras] media-libs/speex )"
DEPEND="${BASICDEPEND} >=dev-util/cmake-2.8.4"
RDEPEND="${BASICDEPEND}"

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local mycmakeargs="
		`cmake-utils_use_enable acetamide AZOTH_ACETAMIDE`
		`cmake-utils_use_enable autopaste AZOTH_AUTOPASTE`
		`cmake-utils_use_enable chathistory AZOTH_CHATHISTORY`
		`cmake-utils_use_enable depester AZOTH_DEPESTER`
		`cmake-utils_use_enable embedmedia AZOTH_EMBEDMEDIA`
		`cmake-utils_use_enable herbicide AZOTH_HERBICIDE`
		`cmake-utils_use_enable hili AZOTH_HILI`
		`cmake-utils_use_enable juick AZOTH_JUICK`
		`cmake-utils_use_enable nativeemoticons AZOTH_NATIVEEMOTICONS`
		`cmake-utils_use_enable p100q AZOTH_P100Q`
		`cmake-utils_use_enable rosenthal AZOTH_ROSENTHAL`
		`cmake-utils_use_enable standardstyles AZOTH_STANDARDSTYLES`
		`cmake-utils_use_enable xoox AZOTH_XOOX`
		`cmake-utils_use_enable xtazy AZOTH_XTAZY`
		"

	cmake-utils_src_configure
}

pkg_postinst() {
	if use rosenthal; then
		einfo " + You have enabled the Azoth Rosenthal plugin for"
		einfo "   spellchecking. It uses Hunspell/Myspell dictionaries,"
		einfo "   so install the ones for languages you use to enable"
		einfo "   spellchecking."
	fi
}
