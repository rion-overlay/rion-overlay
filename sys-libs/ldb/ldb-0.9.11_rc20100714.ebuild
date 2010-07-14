# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"
WANT_AUTOCONF="2.5"
WANT_AUTOMAKE=""

inherit autotools python

DESCRIPTION="An LDAP-like embedded database"
HOMEPAGE="http://ldb.samba.org"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap doc sqlite3 gcov"

RDEPEND="dev-libs/popt
	sys-libs/talloc[compat]
	sys-libs/tdb
	sys-libs/tevent
	sqlite3? ( dev-db/sqlite:3 )
	ldap? ( net-nds/openldap )
	!!=net-fs/samba-4*"

DEPEND="doc? ( dev-libs/libxslt
	app-doc/doxygen )
	${DEPEND}"

RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/ldb-0.9.11"
src_prepare() {
	touch include/config.h.in
	cd ${S}
	cp libreplace/libreplace.m4 . || die

	./autogen.sh

#local IPATHS="-I libreplace -I lib/replace -I ../libreplace -I ../replace -I../../../lib/replace -I ./external"
#	AM_OPTS=${IPATHS}

#eautoreconf ${IPATHS}
#eautoheader ${IPATHS}
#	eautoconf ${IPATHS}
#	eautomake ${IPATHS}
	_elibtoolize
}

src_configure() {

	econf \
		--enable-largefile \
		$(use_with ldap) \
		$(use_with sqlite3) \
		$(use_enable gcov) -C || die ""
}
src_compile() {
	emake -j1 shared-build || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
}
