# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/jupp0r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

inherit cmake

DESCRIPTION="Prometheus Client Library for Modern C++"
HOMEPAGE="https://github.com/jupp0r/prometheus-cpp"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="net-misc/curl
	www-servers/civetweb[cxx]"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_configure() {
	local mycmakeargs=(
		-DUSE_THIRDPARTY_LIBRARIES=OFF
		-DENABLE_TESTING=$(usex test)
	)
	cmake_src_configure
}
