# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/9"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples ntp-timestamp"

RDEPEND="
	>=net-libs/bctoolbox-0.6
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

S="${WORKDIR}/${P}-0"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
		-DENABLE_DOC=$(usex doc)
		-DENABLE_NTP_TIMESTAMP=$(usex ntp-timestamp)
		-DENABLE_PERF=OFF
		-DENABLE_STRICT=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_DEBUG_LOGS=$(usex debug)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins src/tests/*.c
	fi
}
