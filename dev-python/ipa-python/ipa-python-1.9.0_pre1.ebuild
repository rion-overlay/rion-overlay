# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
MY_PV="1.9.0.pre1"
inherit distutils

DESCRIPTION="Set of libraries common to IPA clients and servers"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-python/python-ldap-2.2.1[sasl,ssl]
			dev-python/python-krbV
		|| ( dev-python/acutil app-admin/authconfig )"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/"freeipa-${MY_PV}/ipapython"

src_prepare(){
# Set version
	sed -e s/__VERSION__/1.9.0/ version.py.in > version.py ||die
	perl -pi -e "s:__NUM_VERSION__:122:" version.py ||die

	cp setup.py.in setup.py || die
distutils_src_prepare
}
