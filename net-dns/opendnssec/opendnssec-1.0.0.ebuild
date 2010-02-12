# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.11"

inherit autotools eutils

DESCRIPTION="OpenDNSSEC was created as an open-source turn-key solution for DNSSEC"
HOMEPAGE="http://www.opendnssec.org"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="auditor"

COMMON_DEP="dev-libs/libxml2:2
		=dev-lang/python-2*
		dev-python/4suite
		dev-db/sqlite:3
		>=net-libs/ldns-1.6.2[ssl]"

DEPEND="${COMMON_DEP}"
RDEPEND="${COMMON_DEP}"

src_prepare() {
	eautoreconf
}
src_configure() {
	econf \
		$(use_enable auditor) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
