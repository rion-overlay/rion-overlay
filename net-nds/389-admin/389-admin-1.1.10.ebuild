# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"
MY_PV="1.1.10.a3"
inherit eutils multilib autotools depend.apache

DESCRIPTION="389 Directory Server (admin)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://port389.org/sources/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ipv6"

# USE selinux dropped - gentoo specific
# I`m not selinux man

# TODO snmp agent init script

DEPEND="dev-libs/nss[utils]
		dev-libs/nspr[ipv6?]
		dev-libs/svrcore
		dev-libs/mozldap
		dev-libs/389-adminutil
		dev-libs/cyrus-sasl
		dev-libs/icu
		>=sys-libs/db-4.2.52
		net-analyzer/net-snmp[ipv6?]
		sys-apps/tcp-wrappers[ipv6?]
		sys-libs/pam
		app-misc/mime-types
		~www-apache/mod_restartd-${PV}
		www-apache/mod_nss
		~www-apache/mod_admserv-${PV}
		>=app-admin/389-admin-console-1.1.0
		>=app-admin/389-ds-console-1.1.0
		www-servers/apache:2[apache2_mpms_worker,apache2_modules_actions,apache2_modules_alias,apache2_modules_auth_basic,apache2_modules_authz_default,apache2_modules_mime_magic,apache2_modules_rewrite,apache2_modules_setenvif]"

RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"
need_apache2_2

src_prepare() {

#	epatch "${FILESDIR}/${PV}/"*.patch

	sed -e "s!SUBDIRS!# SUBDIRS!g" -i Makefile.am || die "sed failed"
	sed -e "s!nobody!apache!g" -i configure.ac	  || die "sed failed"
	rm -rf "${S}"/mod_* || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--with-fhs \
		--with-apr-config \
		--with-apxs=${APXS} \
		--with-httpd=${APACHE_BIN} \
				|| die "econf failed"
}

src_install () {

	emake DESTDIR="${D}" install || die "emake failed"
	keepdir /var/log/dirsrv/admin-serv

	# remove redhat style init script.
	rm -rf "${D}"/etc/rc.d
	rm -rf "${D}"/etc/default

	# install gentoo style init script.
	newinitd "${FILESDIR}"/dirsrv-admin.initd dirsrv-admin
	newconfd "${FILESDIR}"/dirsrv-admin.confd dirsrv-admin

	# remove redhat style wrapper scripts
	# and install gentoo scripts.
	rm -rf "${D}"/usr/sbin/*-ds-admin
	dosbin "${FILESDIR}"/*-ds-admin

	# Patch httpd.conf 
	# Source in httpd.conf is patch hell,imho
	cd "${D}"/etc
#	epatch "${FILESDIR}/${PV}"-apache2-httpd.conf.patch || die
}
