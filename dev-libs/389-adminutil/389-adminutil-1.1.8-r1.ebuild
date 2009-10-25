# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"

inherit eutils autotools

DESCRIPTION="389 adminutil"
HOMEPAGE="http://port389.org/"
SRC_URI="http://port389.org/sources/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	>=dev-libs/svrcore-4.0.3
	>=dev-libs/mozldap-6.0.2
	>=dev-libs/cyrus-sasl-2.1.19
	>=dev-libs/icu-3.4
	!dev-libs/adminutil"

RDEPEND="${DEPEND}"
src_prepare() {
	epatch "${FILESDIR}"/389-adminutil-1.1.8-no_icu_pc.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
	    --with-fhs \
		--with-pic ||die "econf failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"
}
