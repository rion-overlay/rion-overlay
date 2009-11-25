# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit multilib cvs

DESCRIPTION="Mozilla LDAP C SDK"
HOMEPAGE="http://wiki.mozilla.org/LDAP_C_SDK"
SRC_URI=""

ECVS_MODULE="mozilla/security"
ECVS_SERVER="cvs-mirror.mozilla.org:/cvsroot"
LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-libs/nss-3.11
	>=dev-libs/nspr-4.6"

RDEPEND="${DEPEND}"

S="${WORKDIR}/"mozilla/security/svrcore
src_configure() {
	econf  --with-pic || die
}

src_install () {
	einstall  || die "emake failed"

	# cope with libraries being in /usr/lib/svrcore
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/svrcore" > "${D}"/etc/env.d/08svrcore

	dodoc ChangeLog INSTALL NEWS TODO README AUTHORS
}
