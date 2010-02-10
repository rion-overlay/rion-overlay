# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"
WANT_AUTOCONF="2.5"
RPM_REV="-3"

inherit  autotools depend.apache eutils pki-dogtag

DESCRIPTION="Token Processing System for Smartcards - Dog Tag system"
HOMEPAGE="http://pki.fedoraproject.org"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="dev-libs/cyrus-sasl
		dev-libs/nss
		dev-libs/nspr
		dev-libs/mozldap
		dev-libs/svrcore
		dev-libs/apr-util[mozldap]
		dev-java/velocity"

RDEPEND="${DEPEND}"

need_apache2_2

src_prepare() {
	 EPATCH_SOURCE="${FILESDIR}/${PV}/" EPATCH_SUFFIX="patch" \
	 EPATCH_FORCE="yes" epatch
	eautoreconf
}
src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable amd64 64bit) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
