# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"

inherit eutils autotools confutils toolchain-funcs

DESCRIPTION="A thread safe high level multi-database connection pool library"
HOMEPAGE="http://www.tildeslash.com/libzdb/"
SRC_URI="http://www.tildeslash.com/libzdb/dist/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mysql postgres +sqlite3 ssl debug doc"

RDEPEND="postgres? ( >=dev-db/postgresql-base-8.0 )
	mysql? ( >=virtual/mysql-4.1 )
	sqlite3? ( >=dev-db/sqlite-3.6.12
		>=sys-devel/gcc-4.1 )
	>=dev-libs/glib-2.8
	dev-libs/openssl"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/libtool
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	confutils_require_any mysql postgres sqlite3
}

src_prepare() {
	epatch "${FILESDIR}"/2.7/*.patch || die
	eautoreconf
}

src_configure() {

	if ( use sqlite3 || use protected ); then
		einfo "You have sqlite3 or protected USE flag"
		einfo "sqlite unlock feature and protect non-API objects"
		einfo "require gcc version > 4.1"
		elog "Check gcc version ..."

		if  [[ $(gcc-version) < 4.1 ]];then
			local myconf=""
			myconf=" --disable-protected "

			ewarn "sqlite unlock feature"
			ewarn "and protect non-API objects feature"
			ewarn "REQUIRE gcc version high 4.1."
			ewarn "Upstream higly recommended build"
			ewarn "this package witch gcc version 4.1 or above."
			ewarn "This feature disabled."
			epause

		else
			elog "Ok, found gcc version above 4.1."
			elog "Protect non-API objects feature is enabled."
			myconf=" --enable-protected "
		fi
	fi

	econf \
		$(use_enable debug profiling ) \
		$(use_with postgres postgresql) \
		$(use_with mysql) \
		$(use_with sqlite3 sqlite) \
		$(use_enable sqlite3 sqliteunlock) \
		$(use_enable ssl openssl) \
		--without-oci \
		${myconf} \
		|| die "econf failed"
}

src_compile() {
	default_src_compile
	if use doc; then
		emake doc || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS CHANGES README
	if use doc;then
		dohtml -r "${S}/doc/api-docs"/* || die
	fi
}
