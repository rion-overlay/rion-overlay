# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="2"

inherit python waf-utils

DESCRIPTION="An LDAP-like embedded database"
HOMEPAGE="http://ldb.samba.org"
SRC_URI="http://www.samba.org/ftp/pub/ldb/ldb-1.1.0.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc sqlite3 gcov"

RDEPEND="dev-libs/popt
	sys-libs/talloc
	sys-libs/tdb
	sys-libs/tevent
	sqlite3? ( dev-db/sqlite:3 )
	!>=net-fs/samba-3.4[ldb]"

DEPEND="doc? ( dev-libs/libxslt
	app-doc/doxygen )
	${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

WAF_BINARY="${S}/buildtools/bin/waf-svn"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}
