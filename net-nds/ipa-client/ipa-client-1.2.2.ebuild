# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

NEED_PYTHON="2.5"
WANT_AUTOMAKE="1.7"

inherit autotools python

DESCRIPTION="Set of libraries common to IPA clients and servers"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-openldap"

DEPEND="dev-libs/popt
		dev-libs/nspr
		dev-libs/nss
		app-crypt/mit-krb5
		dev-libs/svrcore
		dev-libs/cyrus-sasl
		dev-libs/mozldap
	openldap? ( net-nds/openldap )"

RDEPEND="${DEPEND}
		sys-auth/nss_ldap[kerberos,sasl,ssl]
		sys-auth/pam_ldap[sasl,ssl]
		sys-auth/pam_krb5"

S="${WORKDIR}"/"freeipa-${PV}/${PN}"

python_enable_pyc
python_need_rebuild

src_prepare(){
# Set version
sed -e s/__VERSION__/1.2.2/ version.m4.in  > version.m4 || die
	mv version.m4.in version.m4 || die
	epatch "${FILESDIR}/${PV}"/*.patch
	eautoreconf
}

src_configure() {
	econf \
	--enable-maintainer-mode \
	$(use_with  openldap ) || die "econf failure"
}

src_install() {
	emake DESTDIR="${D}" install  || die "emake failed"
	keepdir /var/lib/ipa-client/
	keepdir	/var/lib/ipa-client/sysrestore
	dodir /etc/ipa/

}

pkg_postrm() {
	python_mod_cleanup
}
