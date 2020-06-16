# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Implementation of ZRTP keys exchange protocol"
HOMEPAGE="https://gitlab.linphone.org/BC/public/bzrtp"
SRC_URI="https://gitlab.linphone.org/BC/public/bzrtp/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/bctoolbox:4
	dev-libs/libxml2:2
	dev-db/sqlite:3"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
		-DENABLE_STRICT=OFF
		-DENABLE_TESTS=OFF
	)

	cmake-utils_src_configure
}
