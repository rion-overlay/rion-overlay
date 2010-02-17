# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"
WANT_AUTOCONF="2.5"

inherit  autotools depend.apache eutils multilib

DESCRIPTION="Token Processing System for Smartcards - Dog Tag system"
HOMEPAGE="http://pki.fedoraproject.org"
SRC_URI="http://pki.fedoraproject.org/pki/sources/${PN}/${P}.tar.gz"

KEYWORDS="~amd64"
SLOT=0""
LICENSE="GPL-2"

IUSE="debug"

DEPEND="dev-libs/cyrus-sasl
		dev-libs/nss
		dev-libs/nspr
		dev-libs/mozldap
		dev-libs/svrcore
		dev-libs/apr-util[mozldap]
		dev-java/velocity
		=dev-lang/perl-5*"

RDEPEND="${DEPEND}"

need_apache2_2

src_prepare() {

	 EPATCH_SOURCE="${FILESDIR}/${PV}/" EPATCH_SUFFIX="patch" \
	 EPATCH_FORCE="yes" epatch

	sed \
	-e "s,@APACHE_MODULES_DIR@,/usr/$(get_libdir)/apache2/modules,g" \
	-e "s,@PERL_GENTOO_BASEDIR@,/usr/$(get_libdir)/perl5,g"  -i configure.ac || die
	eautoreconf
}
src_configure() {
	econf \
		--bindir=/usr/bin \
		$(use_enable debug) \
		$(use_enable amd64 64bit) || die
}

src_install() {
	emake DESTDIR="${D}"  install || die

	# Remove RH init script and install Gentoo style init
	rm -fr "${D}"/etc
	rm -fr "${D}"/usr/share
	rm -fr "${D}"doocroot
	rm -fr "${D}"/libexec
#	doinitd "${FILESDIR}"/pki-tpsd
#	dodir /var/lock/subsys/pki-tpsd
#	dodir /var/run/pki	
}
