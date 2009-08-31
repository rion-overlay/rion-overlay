# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools python

DESCRIPTION="Free-IPA server"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-"${PV}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="-openldap"

DEPEND="dev-libs/popt
		=dev-libs/nspr-4*
		=dev-libs/nss-3*
		app-crypt/mit-krb5
		dev-libs/svrcore
		dev-libs/cyrus-sasl
		dev-libs/mozldap
		dev-lang/python
		dev-python/turbogears
	openldap? ( net-nds/openldap )
	net-nds/389-ds-base
	net-nds/389-admin"

RDEPEND="${DEPEND}"
S="${WORKDIR}"/"freeipa-${PV}/${PN}"

src_prepare(){
	# Set version
	cd "${S}"
	sed -e s/__VERSION__/"${PV}"/ version.m4.in  > version.m4 || die "sed failed"

	epatch "${FILESDIR}"/gentoo-configure-ac.patch

	eautoreconf
}

src_configure() {
	
	econf $(use_with  openldap ) || die "econf failure"

	# remowe redhat style init script and install
	# Gentoo init 
	#doinitd "${D}"etc/rc.d/init.d/ipa_kpasswd
	#doinitd "${D}"etc/rc.d/init.d/ipa_webgui
	#rm -fr "${D}"/etc/rc.d	|| die
	
	# keep dirs
	keepdir var/lib/cache/ipa/kpasswd
	keepdir var/lib/cache/ipa/sessions
	keepdir var/lib/lib/ipa/sysrestore/
}

src_install() {
	emake DESTDIR="${D}" install  ||die

	# remowe redhat style init script and install
	# Gentoo init
	doinitd "${D}"etc/rc.d/init.d/ipa_kpasswd
	doinitd "${D}"etc/rc.d/init.d/ipa_webgui
	rm -fr "${D}"/etc/rc.d || die

	# keep dirs
	keepdir var/lib/cache/ipa/kpasswd
	keepdir var/lib/cache/ipa/sessions
	keepdir var/lib/lib/ipa/sysrestore/

	
}
pkg_postrm() {

	python_mod_cleanup /usr/share/ipa/ipagui
}

