# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="LCPackGen — package generator for LeechCraft's repos."
HOMEPAGE="http://leechcraft.org"
EGIT_REPO_URI="git://github.com/0xd34df00d/lcpackgen.git"

inherit cmake-utils git

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-core-4.6
		>=x11-libs/qt-gui-4.6
		>=x11-libs/qt-xmlpatterns-4.6"
RDEPEND="${DEPEND}"
CMAKE_USE_DIR="${S}/src"
CMAKE_MIN_VERSION="2.6"

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	cmake-utils_src_configure
}
