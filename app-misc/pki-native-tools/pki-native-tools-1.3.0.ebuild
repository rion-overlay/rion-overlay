# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"

inherit autotools

DESCRIPTION="Dogtag Certificate System - Native Tools"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/cyrus-sasl
		dev-libs/mozldap[sasl]
		dev-libs/nspr
		dev-libs/nss[utils]
		dev-libs/svrcore
		sys-devel/libtool:1.5"

RDEPEND="dev-libs/cyrus-sasl
		dev-libs/mozldap[sasl]
		dev-libs/nspr
		dev-libs/nss[utils]
		dev-libs/svrcore"

src_prepare() {
	epatch "${FILESDIR}/${PV}/"*.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable amd64 64bit) \
		$(use_enable debug) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc "${S}"/doc/README
}
