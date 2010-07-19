# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_DEPEND="2:2.6"

MY_PV=${PV/_pre/.pre}

inherit python

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

DEPEND=""

S="${WORKDIR}"/freeipa-${MY_PV}/${PN}

python_enable_pyc

src_install() {
	python_set_active_version 2
	insinto $(python_get_libdir)/site-packages/ipalib
	doins -r .
}

pkg_postinst() {
	python_need_rebuild
	python_mod_optimize  /$(python_get_sitedir)/ipalib/*.py
}

pkg_postrm(){
	python_mod_cleanup /$(python_get_sitedir)/ipalib/*.py
}
