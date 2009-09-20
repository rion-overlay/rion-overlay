# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/dclib/dclib-0.3.23.ebuild,v 1.1 2009/06/08 18:39:23 armin76 Exp $

EAPI="2"
inherit autotools
DESCRIPTION="DirectConnect client library"
HOMEPAGE="http://sourceforge.net/projects/wxdcgui"
SRC_URI="mirror://sourceforge/eiskaltdc/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug ssl"

RDEPEND=">=app-arch/bzip2-1.0.2
	>=dev-libs/libxml2-2.4.22
	virtual/libiconv
	ssl? ( >=dev-libs/openssl-0.9.8j )"
DEPEND="${RDEPEND}"

src_prepare() {
	# Gentoo as-need patch
	eautoreconf
}

src_configure() {
	econf 	--disable-rpath \
			--disable-socks \
			--disable-warnings \
			 --disable-xmltest \
		$(use_enable debug) \
		$(use_enable ssl) || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
