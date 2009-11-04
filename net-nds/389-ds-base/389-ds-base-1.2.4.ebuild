# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils multilib flag-o-matic autotools

DESCRIPTION="389 Directory Server (core files and daemons)"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.bz2"


LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +pam-passthru +dna +bitwise presence kerberos selinux"

ALL_DEPEND="dev-libs/nss[utils]
		dev-libs/nspr
		dev-libs/svrcore
		dev-libs/mozldap
	>=dev-libs/cyrus-sasl-2.1.19
	>=dev-libs/icu-3.4
	>=sys-libs/db-4.5
	>=net-analyzer/net-snmp-5.1.2
	dev-libs/openssl
	sys-apps/tcp-wrappers
	sys-libs/pam
	sys-libs/zlib
	dev-perl/perl-mozldap
	dev-libs/libpcre:3
	kerberos? ( app-crypt/mit-krb5 )"

DEPEND="${ALL_DEPEND}
		dev-util/pkgconfig
		sys-devel/libtool:1.5"

RDEPEND="${ALL_DEPEND}
		virtual/perl-Time-Local
		virtual/perl-MIME-Base64"

pkg_setup() {
	enewgroup dirsrv
	enewuser dirsrv -1 -1 -1 dirsrv
}

src_prepare() {

	epatch "${FILESDIR}/${PV}/"*.patch

	eautoreconf
}

src_configure() {
	append-ldflags -Wl,--as-needed

	econf $(use_enable debug) \
		$(use_enable pam-passthru) \
		$(use_enable dna) \
		$(use_enable bitwise) \
		$(use_enable presence) \
		$(use_with kerberos) \
		--enable-maintainer-mode \
		--enable-ldapi \
		--enable-autobind \
		--with-fhs || die "econf failed"

#      $(use_with selinux) disabel due bug in
# configure
}

src_compile() {
	append-lfs-flags

	emake || die "compile failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	# install not installed header
	insinto /usr/include/dirsrv
	doins ldap/servers/slapd/slapi-plugin.h
	# for build free-ipa require winsync-plugin
	doins ldap/servers/plugins/replication/winsync-plugin.h

	# make sure perl scripts have a proper shebang
	cd "${D}"/usr/share/dirsrv/script-templates/

	for i in $(find ./  -iname '*.pl') ;do
		sed -i -e 's/#{{PERL-EXEC}}/#\!\/usr\/bin\/perl/' $i || die
	done

	# remove redhat style init script and install gentoo style
	rm -rf "${D}"/etc/rc.d || die
	rm -rf "${D}"/etc/default || die

	newinitd "${FILESDIR}"/dirsrv.initd dirsrv
	newconfd "${FILESDIR}"/dirsrv.confd dirsrv

	# cope with libraries being in /usr/lib/dirsrv
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/dirsrv" > "${D}"/etc/env.d/08dirsrv

	# create the directory where our log file and database
	diropts -m 0750 -o dirsrv -g dirsrv

	keepdir /var/lock/dirsrv
	keepdir /var/lib/dirsrv

}
