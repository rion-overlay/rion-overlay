# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ library to manipulate VCard standard format"
HOMEPAGE="https://gitlab.linphone.org/BC/public/belcard"
SRC_URI="https://gitlab.linphone.org/BC/public/belcard/-/archive/${PV}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

DEPEND="net-libs/bctoolbox:4
	dev-libs/belr:4"
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
