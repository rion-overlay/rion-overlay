# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

DESCRIPTION="Wt is a C++ library for developing interactive web applications."
HOMEPAGE="http://webtoolkit.eu"
SRC_URI="mirror://sourceforge/witty/wt-${PV}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/boost-1.39.0"
RDEPEND="${DEPEND}"

CMAKE_MIN_VERSION="2.6"

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	local mycmakeargs="-DDESTDIR=${D}"
	cmake-utils_src_configure
}
