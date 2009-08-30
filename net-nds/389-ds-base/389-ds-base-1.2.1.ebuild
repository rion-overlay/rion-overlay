# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib flag-o-matic autotools

DESCRIPTION="389 Directory Server (base)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://port389.org/sources/${P}.tar.bz2
	http://ftp.mars.arge.at/389-ds/1.2.x/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=dev-libs/nss-3.11.4
	>=dev-libs/nspr-4.6.4
	>=dev-libs/svrcore-4.0.3
	>=dev-libs/mozldap-6.0.2
	>=dev-libs/cyrus-sasl-2.1.19
	>=dev-libs/icu-3.4
	>=sys-libs/db-4.2.52
	>=net-analyzer/net-snmp-5.1.2
	sys-apps/lm_sensors
	app-arch/bzip2
	dev-libs/openssl
	sys-apps/tcp-wrappers
	sys-libs/pam
	sys-libs/zlib
	dev-perl/perl-mozldap
	!net-nds/fedora-ds-base"

pkg_setup() {
	enewgroup dirsrv
	enewuser dirsrv -1 -1 -1 dirsrv
}

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch ${FILESDIR}/bug435774.patch
	sed -e "s!nobody!dirsrv!g" -i configure.ac
	eautoreconf
}

src_compile() {
	append-flags -D_GNU_SOURCE
	econf $(use_enable debug) \
	--with-fhs || die "econf failed"

#	--with-db=yes \
#	--with-ldapsdk=yes \
#	--with-svrcore=yes \
#	--with-nss=yes \
#	--with-nspr=yes \
#	--with-icu=yes \
#	$(use_enable pam pam-passthru) \
#	$(use_enable ldapi) \
#	$(use_with sasl sasl yes) \
#	$(use_with snmp netsnmp yes) \


	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake failed"

	# install not installed header
	insinto /usr/include/dirsrv
	doins ldap/servers/slapd/slapi-plugin.h

	# make sure perl scripts have a proper shebang
	dosed 's|#{{PERL-EXEC}}|#!/usr/bin/perl|' /usr/share/dirsrv/script-templates/template-*.pl

	# remove redhat style init script and install gentoo style
	rm -rf "${D}"/etc/rc.d
	rm -rf "${D}"/etc/default
	newinitd "${FILESDIR}"/dirsrv.initd dirsrv
	newconfd "${FILESDIR}"/dirsrv.confd dirsrv

	# cope with libraries being in /usr/lib/dirsrv
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/dirsrv" > "${D}"/etc/env.d/08dirsrv

	keepdir /var/lock/dirsrv
	keepdir /var/lib/dirsrv

}

pkg_postinst() {
	chown dirsrv:dirsrv ${ROOT}/var/lock/dirsrv
	chown dirsrv:dirsrv ${ROOT}/var/lib/dirsrv
}
