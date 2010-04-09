# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/rb_libtorrent/rb_libtorrent-0.14.6.ebuild,v 1.9 2010/03/27 17:29:24 yngwin Exp $

EAPI="2"
inherit cmake-utils

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

DEPEND="dev-libs/boost
	python? ( dev-libs/boost[python] dev-lang/python:2.6[threads] )
	crypt? ( dev-libs/openssl )
	geoip? ( dev-libs/geoip )
	zlib? ( sys-libs/zlib )
	examples? ( !net-p2p/mldonkey )"  #292998
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	local CMAKE_BUILD_TYPE
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	cmake-utils_src_configure
	local mycmakeargs=($(cmake-utils_use log logging)
		$(cmake-utils_use crypt encryption)
		$(cmake-utils_use geoip geoip)
		$(cmake-utils_use pool-allocators pool-allocators)
		$(cmake-utils_use dht dht))

	cmake-utils_src_configure
}

src_install() {
	dodoc ChangeLog AUTHORS NEWS README || die 'dodoc failed'
	if use doc ; then
		dohtml docs/* || die "Could not install HTML documentation"
	fi
	cmake-utils_src_install
}
