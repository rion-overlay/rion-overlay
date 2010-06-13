# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Qross is a KDE-free version of Kross."
HOMEPAGE="http://github.com/0xd34df00d/Qross"

EGIT_REPO_URI="git://github.com/0xd34df00d/Qross.git"
EGIT_PROJECT="qross-${PV}"

inherit git cmake-utils

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-core-4.6
		>=x11-libs/qt-gui-4.6
		>=x11-libs/qt-script-4.6"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src/qross"

src_unpack() {
	git_src_unpack

	cd "${S}"
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	cmake-utils_src_configure
}
