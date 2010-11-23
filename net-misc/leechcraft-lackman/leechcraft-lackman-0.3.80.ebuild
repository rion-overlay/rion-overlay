# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="LackMan, LeechCraft Package Manager for extensions, scripts, themes etc."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}
		>=x11-libs/qt-webkit-4.6"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	local mycmakeargs="-DTEST=False"
	cmake-utils_src_configure
}
