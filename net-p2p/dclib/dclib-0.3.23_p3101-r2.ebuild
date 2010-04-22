# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

inherit autotools

DESCRIPTION="DirectConnect client library"
HOMEPAGE="http://sourceforge.net/projects/wxdcgui"
SRC_URI="mirror://sourceforge/eiskaltdc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug socks5 ssl"

RDEPEND=">=app-arch/bzip2-1.0.2
	>=dev-libs/libxml2-2.4.22
	virtual/libiconv
	socks5? ( net-proxy/dante )
	ssl? ( <dev-libs/openssl-1 )"
DEPEND="${RDEPEND}"

src_prepare() {
	# Gentoo as-need patch
	epatch "${FILESDIR}"/*-asneeded.patch || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-rpath \
		$(use_enable socks5 socks) \
		--disable-xmltest \
		$(use_enable debug) \
		$(use_enable ssl) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
