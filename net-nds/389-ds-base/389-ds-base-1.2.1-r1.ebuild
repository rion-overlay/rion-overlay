# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Честно стырил по известному адресу
# Oh, QA не проходит, буду клепать.

EAPI=2

inherit eutils multilib flag-o-matic autotools

DESCRIPTION="389 Directory Server (base)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~x86"
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
	app-crypt/mit-krb5
	!net-nds/fedora-ds-base"


RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup dirsrv
	enewuser dirsrv -1 -1 -1 dirsrv
}

src_prepare() {
	sed -i -e 's/nobody/dirsrv/g' configure.ac
	eautoreconf
}

src_configure() {
	append-flags -D_GNU_SOURCE
	econf $(use_enable debug) \
	--with-fhs || die "econf failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	# install not installed header
	insinto /usr/include/dirsrv
	doins ldap/servers/slapd/slapi-plugin.h

	# make sure perl scripts have a proper shebang
	cd "${D}"/usr/share/dirsrv/script-templates/

	for i in $(find ./  -iname '*.pl') ;do
		sed -i -e 's/#{{PERL-EXEC}}/#\!\/usr\/bin\/perl/' $i || die
	done

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
	chown dirsrv:dirsrv "${ROOT}"/var/lock/dirsrv
	chown dirsrv:dirsrv "${ROOT}"/var/lib/dirsrv
}
