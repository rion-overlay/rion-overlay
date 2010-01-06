# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit distutils

DESCRIPTION="Set of libraries common to IPA clients and servers"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-1.2.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-python/python-ldap-2.2.1[sasl,ssl]
			dev-python/python-krbV
		|| ( dev-python/acutil app-admin/authconfig )"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/"freeipa-${PV}/${PN}"

src_configure(){
# Set version
sed -e s/__VERSION__/1.2.1/ version.py.in > version.py ||die

	perl -pi -e "s:__NUM_VERSION__:121:" version.py ||die

	mv setup.py.in setup.py
}
