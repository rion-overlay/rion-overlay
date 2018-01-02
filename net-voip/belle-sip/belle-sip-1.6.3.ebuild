# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C object oriented SIP Stack."
HOMEPAGE="http://www.linphone.org/technical-corner/belle-sip/overview"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE="examples test -tunnel"
REQUIRED_USE=""

DEPEND="${RDEPEND}
	net-libs/bctoolbox
	dev-java/antlr:3
	dev-libs/antlr-c
	dev-util/intltool
	sys-devel/libtool
	virtual/pkgconfig
	test? ( >=dev-util/cunit-2.1_p3[ncurses] )"

S="${WORKDIR}/${P}-0"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
		-DENABLE_STRICT=OFF
		-DENABLE_TUNNEL=$(usex tunnel)
		-DENABLE_TESTS=$(usex test)
	)

	# other options
	#	-DENABLE_RTP_MAP_ALWAYS_IN_SDP=$(usex sdp)

	cmake-utils_src_configure
}

src_test() {
	default
	test -d tester || die
	emake -C tester test
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tester/*.c
	fi
}
