# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit apache-module ssl-cert eutils autotools


KEYWORDS="~amd64 ~x86"

DESCRIPTION="An Apache module to implementing the admin server functionality for 389 Admin/Directory Server"
HOMEPAGE="http://port389.org"
SRC_URI="http://port389.org/sources/389-admin-${PV}.tar.bz2"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/mozldap-6.0.2
	>=dev-libs/389-adminutil-1.1.3
	>=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	>=dev-libs/icu-3.4
	>=dev-libs/apr-util-1.3.9-r100[mozldap,ldap]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/389-admin-${PV}/${PN}"

#APACHE2_MOD_CONF="48_${PN}"
APACHE2_MOD_DEFINE="ADMSERV"

DOCFILES="LICENSE README"

need_apache2

pkg_setup() {
	if ! built_with_use 'dev-libs/apr-util' mozldap ; then
		eerror "dev-libs/apr-util is missing Mozilla LDAP support. For apache to have"
		eerror "mozldap support, apr-util must be built with the mozldap USE-flag"
		eerror "enabled."
		eerror ""
		eerror "plz remerge dev-libs/apr-util and www-server/apache with mozldap useflag"
		eerror "enabled."
		eerror ""
		die "mozldap USE-flag enabled while not supported in apr-util"
	fi

	if ! built_with_use 'dev-libs/apr-util' ldap ; then
		eerror "dev-libs/apr-util is missing LDAP support. For apache to have"
		eerror "ldap support, dev-libs/apr-util & www-server/apache must be built"
		eerror "with the ldap USE-flag enabled."
		eerror ""
		eerror "plz remerge dev-libs/apr-util & www-server/apache with ldap useflag"
		eerror "enabled."
		eerror ""
		die "ldap USE-flag enabled while not supported in dev-libs/apr-util"
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"
	 eautoreconf
}

src_compile() {
	econf --with-apxs=${APXS} \
	--with-adminutil=/usr \
	|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	apache-module_src_install
}
