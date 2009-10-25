# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib autotools depend.apache

DESCRIPTION="389 Directory Server (admin)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://port389.org/sources/${P}.tar.bz2
	http://ftp.mars.arge.at/389-ds/1.1.x/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="dev-libs/nss[utils]
		dev-libs/nspr
		dev-libs/svrcore
		dev-libs/mozldap
		dev-libs/389-adminutil
		dev-libs/cyrus-sasl
		dev-libs/icu
		>=sys-libs/db-4.2.52
		net-analyzer/net-snmp
		sys-apps/tcp-wrappers
		sys-libs/pam
		app-misc/mime-types
		www-apache/mod_restartd
		www-apache/mod_nss
		www-apache/mod_admserv
		>=app-admin/389-admin-console-1.1.0
		>=app-admin/389-ds-console-1.1.0"

RDEPEND="${DEPEND}"

need_apache2_2

src_prepare() {

	epatch "${FILESDIR}"/fedora-ds-admin-1.1.5-cfgstuff-1.patch

	sed -e "s!SUBDIRS!# SUBDIRS!g" -i Makefile.am
	sed -e "s!nobody!apache!g" -i configure.ac
	rm -rf "${S}"/mod_* || die

	eautoreconf
}

src_compile() {
	econf $(use_enable debug) \
	--with-fhs \
	--with-httpd=${APACHE_BIN} \
	|| die "econf failed"

	emake || die "emake failed"
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
}
