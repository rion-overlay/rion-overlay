# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools python

DESCRIPTION="Set of libraries common to IPA clients and servers"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-1.2.1.tar.gz"

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
		dev-lang/python
	openldap? ( net-nds/openldap )"

RDEPEND="${DEPEND}"
S="${WORKDIR}"/"freeipa-${PV}/${PN}"

python_enable_pyc
python_need_rebuild

src_unpack(){
	default
}

src_prepare(){
# Set version
sed -e s/__VERSION__/1.2.1/ version.m4.in  > version.m4
	mv version.m4.in version.m4 || die

	eautoreconf
}

src_configure() {
	econf $(use_with  openldap ) || die "econf failure"
}

src_install() {
	emake DESTDIR="${D}" install  || die "emake failed"

}

pkg_postrm() {
	python_mod_cleanup
}
