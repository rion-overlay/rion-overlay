# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="FreeIPA server admintootls"
HOMEPAGE="http://www.freeipa.org"

SRC_URI="http://freeipa.org/downloads/src/freeipa-"${PV}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/python
		dev-python/python-krbV
		dev-python/PyKerberos
		dev-python/pyasn1"

S="${WORKDIR}"/"freeipa-${PV}/${PN}"

src_install() {

	rm "${S}"/ipa-admintools.spec.in # :)

	dodir /usr/sbin
	insinto /usr/share
	dosbin  "${S}"/ipa-*
	doman  "${S}"/man/ipa*
}
