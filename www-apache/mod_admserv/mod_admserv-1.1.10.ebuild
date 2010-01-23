# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"
MY_PV="1.1.10.a3"
inherit apache-module eutils autotools

KEYWORDS="~amd64 ~x86"
DESCRIPTION="An Apache module to implementing the admin server functionality for 389 Admin/Directory Server"
HOMEPAGE="http://port389.org"
SRC_URI="http://port389.org/sources/389-admin-${MY_PV}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/mozldap-6.0.2
	>=dev-libs/389-adminutil-1.1.3
	>=dev-libs/nss-3.11.4[utils]
	>=dev-libs/nspr-4.6.4
	>=dev-libs/icu-3.4
	>=dev-libs/apr-util-1.3.9-r100[mozldap,ldap]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/389-admin-${PV}/${PN}"

#APACHE2_MOD_CONF="48_${PN}"
APACHE2_MOD_DEFINE="ADMSERV"

DOCFILES="LICENSE README"

need_apache2

src_prepare() {

	epatch "${FILESDIR}/${PV}"/*.patch

	eautoreconf
}

src_configure() {

	econf \
		--with-apxs=${APXS} \
			|| die "econf failed"
}

src_compile() {
	emake || die
}

src_install() {
	apache-module_src_install
}
