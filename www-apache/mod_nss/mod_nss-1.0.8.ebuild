# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module ssl-cert

KEYWORDS="~amd64 ~x86"

DESCRIPTION="SSL/TLS module for the Apache HTTP server"
HOMEPAGE="http://directory.fedoraproject.org/wiki/Mod_nss"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4"
RDEPEND="${DEPEND}"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="NSS"

DOCFILES="LICENSE NOTICE README"

need_apache2

src_compile() {
	econf --with-apxs=${APXS} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	mv -f .libs/libmodnss.so .libs/"${PN}".so

	dosbin gencert nss_pcache
	dohtml docs/mod_nss.html

	apache-module_src_install
}
