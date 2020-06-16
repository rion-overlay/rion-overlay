# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils

DESCRIPTION="Open Real-time Transport Protocol (RTP, RFC3550) stack"
HOMEPAGE="https://gitlab.linphone.org/BC/public/ortp"
SRC_URI="https://gitlab.linphone.org/BC/public/ortp/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples ntp-timestamp"

RDEPEND="
	net-libs/bctoolbox:4
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"

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
