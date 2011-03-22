# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"

inherit eutils pam autotools confutils

DESCRIPTION="PAM Credential Caching Module"
HOMEPAGE="http://www.padl.com/OSS/pam_ccreds.html"
SRC_URI="http://www.padl.com/download/${P}.tar.gz"

IUSE="+ssl gcrypt"
LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sys-libs/pam-0.72
		>=sys-libs/db-4.2
		gcrypt? ( >=dev-libs/libgcrypt-1.4.0 )
		!gcrypt? ( dev-libs/openssl )
		"

RDEPEND="${DEPEND}"

pkg_setup() {
	confutils_use_conflict ssl gcrypt
	confutils_require_one ssl gcrypt
}
src_prepare() {
	epatch "${FILESDIR}/${PV}"/*.patch
	sed -e "s|@pam_dir@/security|$(getpam_mod_dir)|" -i Makefile.am || die
	eautoreconf
}

src_configure() {
	local myconf=""
	use gcrypt  &&  myconf="--enable-gcrypt"

	econf ${myconf} || die "econf failed"
}
src_install() {
	dopammod pam_ccreds.so

	# Credentials cache file is /var/cache/.security.db
	dodir /var/cache/

	dosbin cc_{dump,test} ccreds_chkpwd
	dodoc AUTHORS ChangeLog NEWS README pam.conf
}
