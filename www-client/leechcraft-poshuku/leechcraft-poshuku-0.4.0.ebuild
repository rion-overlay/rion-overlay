# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit confutils leechcraft

DESCRIPTION="Poshuku, the full-featured web browser plugin for LeechCraft."

IUSE="debug idn sqlite postgres"
DEPEND="=net-misc/leechcraft-core-${PV}[postgres?,sqlite?]
		>=x11-libs/qt-webkit-4.6
		idn? ( net-dns/libidn )"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_setup() {
	confutils_require_any postgres sqlite
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local mycmakeargs="$(cmake-utils_use_enable idn IDN)"

	cmake-utils_src_configure
}
