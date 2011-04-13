# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="2:2.5"

MY_PV=${PV/_pre/.pre}
inherit distutils

DESCRIPTION="Python libraries used by IPA"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=dev-python/python-ldap-2.2.1[sasl,ssl]
			dev-python/python-krbV
			app-crypt/gnupg
			dev-python/pyopenssl
			dev-python/python-nss
		|| ( dev-python/acutil app-admin/authconfig )"

DEPEND="${RDEPEND}
		dev-python/setuptools"

S="${WORKDIR}"/freeipa-${MY_PV}/${PN}

python_enable_pyc

DOCS="README"

src_prepare(){
# Set version
sed -e s/__VERSION__/1.9.0/ version.py.in > version.py ||die

	perl -pi -e "s:__NUM_VERSION__:190:" version.py ||die

	cp setup.py.in setup.py || die

	distutils_src_prepare
}

pkg_postinst() {
	python_mod_optimize  /$(python_get_sitedir)/ipapython/*.py
}
pkg_postrm(){
	python_mod_cleanup /$(python_get_sitedir)/ipapython/*.py
}
