# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multilib

DESCRIPTION="LaunchDarkly Client-side SDK for C/C++"
HOMEPAGE="https://launchdarkly.com/"
SRC_URI="https://github.com/launchdarkly/c-client-sdk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/c-client-sdk-${PV}"

src_prepare() {
	sed -i -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dolib.so "${WORKDIR}/c-client-sdk-${PV}_build"/libldclientapicpp.a
	insinto /usr/include
	doins -r cpp/include/launchdarkly
}
