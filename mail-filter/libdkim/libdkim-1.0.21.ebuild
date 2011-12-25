# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib toolchain-funcs

DESCRIPTION="A library to verify and create signatures of e-mail headers."
HOMEPAGE="http://libdkim.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/openssl
	app-arch/unzip"
RDEPEND="!mail-filter/libdkim-exim
	dev-libs/openssl"

S=${WORKDIR}/${PN}/src

src_prepare() {
	ecvs_clean
	# upstream claims to be portable, but isn't very
	epatch "${FILESDIR}/${PN}-gentoo.patch"
	epatch "${FILESDIR}/${PN}-extra-options.patch"
}

src_compile() {
	tc-export CXX
	emake LIBDIR=$(get_libdir)
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc ../README
}
