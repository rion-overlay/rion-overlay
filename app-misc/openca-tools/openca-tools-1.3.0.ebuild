# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WANT_AUTOMAKE="1.11"

inherit autotools

DESCRIPTION="This package contains the prerequisites for installing OpenCA"
HOMEPAGE="http://www.openca.org"
SRC_URI="mirror://sourceforge/openca/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug"

DEPEND="dev-util/pkgconfig"
RDEPEND=">=dev-libs/openssl-0.9.7"

src_prepare() {

	eautoreconf
}

src_configure () {
	econf \
	--with-openca-user=openca \
	--with-openca-group=openca \
	$(use_enable debug) || die "econf failed"
}

src_install () {

	emake DESTDIR="${ED}"  install || die "install failed"

	rm -fr "${ED}"/usr/share/man || die

	dodoc AUTHORS INSTALL  NEWS README  VERSION
}

pkg_setup() {
		enewgroup openca
		enewuser openca -1 -1 /dev/null openca
}
