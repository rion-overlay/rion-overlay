# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="https://libtorrent.svn.sourceforge.net/svnroot/libtorrent/branches/RC_0_15"

inherit eutils cmake-utils subversion

MY_P="libtorrent-rasterbar"
S=${WORKDIR}/${MY_P}

DESCRIPTION="BitTorrent library written in C++ for *nix."
HOMEPAGE="http://www.rasterbar.com/products/libtorrent/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug examples test +crypt geoip +resolvecountries log verbose"

DEPEND="sys-libs/zlib
	|| ( >=dev-libs/boost-1.35
		( ~dev-libs/boost-1.34.1 dev-cpp/asio ) )"
RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	mycmakeargs="${mycmakeargs}
				-Dbuild_examples=OFF
				-Dbuild_tests=OFF
				-Dresolve-countries=OFF
				-Dencryption=OFF
				$(cmake-utils_use examples build_examples)
				$(cmake-utils_use test build_tests)
				$(cmake-utils_use resolvecountries resolve-countries)
				$(cmake-utils_use crypt encryption)
				$(cmake-utils_use geoip geoip)
				$(cmake-utils_use log logging)
				$(cmake-utils_use verbose verbose-logging)"
	[ "$(get_libdir)" = "lib64" ] && mycmakeargs="${mycmakeargs}
		-DRESPECTLIB64=True"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog AUTHORS NEWS README
}
