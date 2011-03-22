# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

EGIT_REPO_URI="git://github.com/0xd34df00d/Qross.git"
EGIT_PROJECT="qross-${PV}"
PYTHON_DEPEND="2"

inherit python cmake-utils git

DESCRIPTION="Python scripting backend for Qross."
HOMEPAGE="http://github.com/0xd34df00d/Qross"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="=dev-libs/qrosscore-${PV}"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src/bindings/python/qrosspython"
CMAKE_MIN_VERSION="2.8"

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	cmake-utils_src_configure
}
