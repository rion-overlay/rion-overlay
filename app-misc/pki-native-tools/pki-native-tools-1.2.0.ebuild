# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"

inherit autotools rpm

DESCRIPTION="Dogtag Certificate System - Native Tools"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/download/pki/1.2.0/fc11/SRPMS/pki-native-tools-1.2.0-2.fc11.src.rpm"

KEYWORDS="~amd64 ~x86"
SLOT=0
LICENSE="GPL-2-with-exceptions"

IUSE="debug"
COMMON_DEPEND="dev-libs/cyrus-sasl
		dev-libs/mozldap
		dev-libs/nspr
		dev-libs/nss
		dev-libs/svrcore"
DEPEND="${COMMON_DEPEND}
		app-arch/unzip"
RDEPEND="${COMMON_DEPEND}"

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
