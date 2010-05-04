# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.11"

inherit multilib eutils autotools

DESCRIPTION="Kerberos 5 PAM Authentication Module"
HOMEPAGE="http://www.eyrie.org/~eagle/software/pam-krb5"
SRC_URI="http://archives.eyrie.org/software/kerberos/pam-krb5-${PV}.tar.gz"

LICENSE="|| ( BSD-2 GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/krb5
		sys-libs/pam"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		  --libdir=/$(get_libdir)\
		  || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc CHANGES CHANGES-old NEWS README TODO
}
