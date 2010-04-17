# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python cmake-utils
MY_P=${P/rb_/}
MY_P=${MY_P/torrent/torrent-rasterbar}

DESCRIPTION="C++ BitTorrent implementation focusing on efficiency and scalability"
HOMEPAGE="http://www.rasterbar.com/products/libtorrent/"
SRC_URI="mirror://sourceforge/libtorrent/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug doc +crypt examples +dht geoip log +pool-allocators python test zlib"
RESTRICT="test"

RDEPEND="dev-libs/boost
	python? ( dev-libs/boost[python] dev-lang/python:2.6[threads] )
	crypt? ( dev-libs/openssl )
	geoip? ( dev-libs/geoip )
	zlib? ( sys-libs/zlib )
	examples? ( !net-p2p/mldonkey )"  #292998
DEPEND="${RDEPEND}
	>=sys-devel/libtool-2.2.6
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS="ChangeLog AUTHORS NEWS README"

src_prepare(){
	if use python; then
		cd "${S}"/bindings/python
		python_set_active_version 2.6
		distutils_src_prepare
	fi
}

src_configure() {
	python_set_active_version 2.6
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local mycmakeargs=($(cmake-utils_use log logging)
		$(cmake-utils_use crypt encryption)
		$(cmake-utils_use geoip geoip)
		$(cmake-utils_use pool-allocators pool-allocators)
		$(cmake-utils_use dht dht))

	cmake-utils_src_configure
}

src_install() {
	if use doc ; then
		dohtml docs/* || die "Could not install HTML documentation"
	fi
	cmake-utils_src_install
}

pkg_postinst() {
use python && python_need_rebuild
}

