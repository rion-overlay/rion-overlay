# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit apache-module  autotools

DESCRIPTION="Apache 2 module that lets the user configure remote CRL"
HOMEPAGE="http://directory.fedoraproject.org/wiki/Mod_revocator"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
LICENSE="Apache-2.0"

ALLDEPEND=">=dev-libs/nss-3.12.6-r100
		dev-libs/nspr
		net-nds/openldap
		www-apache/mod_nss"

DEPEND="sys-devel/bison
		sys-devel/flex
		dev-util/pkgconfig
		${ALLDEPEND}"

RDEPEND="${ALLDEPEND}"
need_apache2_2
APACHE2_MOD_FILE=".libs/mod_revocator.so"

src_prepare() {
	eautoreconf
}

src_configure() {

	econf \
	--enable-openldap  || die ""
}

src_compile() {
	# not use apache-module.eclass build
	emake ||die
}

src_install() {
	mv .libs/libmodrev.so .libs/"${PN}".so
	dobin	 ldapget
	dobin  crlhelper

	apache-module_src_install

}
