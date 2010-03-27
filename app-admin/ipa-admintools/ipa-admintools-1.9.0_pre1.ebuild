# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="IPA administrative tools"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-1.9.0.pre1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-python/python-ldap-2.2.1[sasl,ssl]
			dev-python/python-krbV
			dev-python/configobj"

DEPEND="${RDEPEND}
		dev-python/setuptools"

S="${WORKDIR}"/freeipa-1.9.0.pre1

src_install() {
	dobin ipa
	dosbin install/tools/ipa-fix-CVE-2008-327
	dosbin install/tools/ipa-compat-manage
	dosbin install/tools/ipa-ldap-updater
	dosbin install/tools/ipa-nis-manage
}
