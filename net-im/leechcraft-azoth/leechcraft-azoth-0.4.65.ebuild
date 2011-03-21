# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Azoth, the modular IM client for LeechCraft."

IUSE="debug +xoox +chathistory +p100q"
DEPEND="=net-misc/leechcraft-core-${PV}
		>=x11-libs/qt-webkit-4.6.0
		xoox? ( =net-libs/qxmpp-0.3.0_pre07022011[extras] )"
RDEPEND="${DEPEND}"

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local mycmakeargs="
		`cmake-utils_use_enable chathistory AZOTH_CHATHISTORY`
		`cmake-utils_use_enable p100q AZOTH_P100Q`
		`cmake-utils_use_enable xoox AZOTH_XOOX`
		"

	cmake-utils_src_configure
}
