# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="C object oriented SIP Stack."
HOMEPAGE="http://www.linphone.org/technical-corner/belle-sip/overview"
SRC_URI="mirror://nongnu/linphone/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

SLOT="0"

IUSE="debug examples test +tls -tunnel +zlib"
REQUIRED_USE=""

DEPEND="${RDEPEND}
	dev-java/antlr:3
	dev-libs/antlr-c
	dev-util/intltool
	sys-devel/libtool
	virtual/pkgconfig
	test? ( >=dev-util/cunit-2.1_p3[ncurses] )"

src_prepare() {
	default
	sed -i -e 's,-Werror,,' configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable tls)
		$(use_enable tunnel)
		$(use_enable test tests)
		$(use_enable zlib)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	default
	test -d tester || die
	emake -C tester test
}

src_install() {
	default
	prune_libtool_files

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tester/*.c
	fi
}
