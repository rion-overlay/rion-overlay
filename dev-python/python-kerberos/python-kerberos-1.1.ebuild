# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.7"

inherit  base distutils

DESCRIPTION="Python package is a high-level wrapper for Kerberos (GSSAPI) operations"
HOMEPAGE="http://trac.calendarserver.org/projects/calendarserver/browser/PyKerberos"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-crypt/mit-krb5"
RDEPEND="${DEPEND}"

PATCHES=(${FILESDIR}/PyKerberos-delegation.patch)
# Pull from SVN
# svn export
# http://svn.calendarserver.org/repository/calendarserver/PyKerberos/tags/release/PyKerberos-1.1/
# python-kerberos-1.1
# tar czf python-kerberos-%{version}.tar.gz python-kerberos-%{version}

# Test required network connections
RESTRICT="test"

DOCS=(README.txt )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	python_need_rebuild
}

src_prepare() {
	base_src_prepare
	distutils_src_prepare
}
