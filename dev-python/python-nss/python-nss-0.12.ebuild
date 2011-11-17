# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-nss/python-nss-0.8-r1.ebuild,v 1.1 2011/10/31 20:01:46 maksbotan Exp $

EAPI="4"

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils versionator

MY_PV=$(replace_all_version_separators  '_' )
DESCRIPTION="Python bindings for Network Security Services (NSS)"
HOMEPAGE="http://www.mozilla.org/projects/security/pki/python-nss/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/security/${PN}/releases/PYNSS_RELEASE_${MY_PV}/src/${P}.tar.bz2"

LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="=dev-libs/nss-3.12*
	dev-libs/nspr
	doc? ( dev-python/docutils
			dev-python/epydoc )"

RDEPEND="${DEPEND}"

DOCS="README doc/ChangeLog"

src_install() {
	distutils_src_install

	if use doc; then
		einfo "Generating API documentation..."

		mkdir "${S}"/doc/html
		PYTHONPATH="${ED}$(python_get_sitedir -f)" epydoc --html --docformat restructuredtext \
			-o "${S}"/doc/html \
			 "$(ls -d build-$(PYTHON -f --ABI)/lib.*)/nss"

		dohtml -r "${S}"/doc/html/
		insinto /usr/share/doc/"${PF}"
		doins -r ./test
		insinto /usr/share/doc/"${PF}"/examples
		doins doc/examples/*.py
	fi
}
