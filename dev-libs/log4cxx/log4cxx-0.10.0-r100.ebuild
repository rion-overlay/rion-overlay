# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# 389 overlay, rewrite official ebuild add mozldap :)

EAPI="2"

inherit eutils

MY_P="apache-${P}"

DESCRIPTION="Library of C++ classes for flexible logging to files, syslog and other destinations"
HOMEPAGE="http://logging.apache.org/log4cxx/"
SRC_URI="mirror://apache/dist/logging/${PN}/${PV}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc iodbc unicode odbc smtp +mozldap"

RDEPEND="dev-libs/apr:1
	dev-libs/apr-util:1
	odbc? (
		iodbc? ( >=dev-db/libiodbc-3.52.4 )
		!iodbc? ( dev-db/unixODBC ) )
	smtp? ( net-libs/libesmtp )
	mozldap? ( dev-libs/mozldap )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use iodbc && ! use odbc ; then
		elog "Please enable the odbc USE-flag as well if you want odbc-support through iodbc."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-missing_includes.patch"
	epatch "${FILESDIR}/${PV}-gcc44.patch"
}

src_configure() {
	local myconf
	use smtp && myconf="${myconf} --with-SMTP=libesmtp"
	if use odbc ; then
		if use iodbc ; then
			myconf="${myconf} --with-ODBC=iODBC"
		else
			myconf="${myconf} --with-ODBC=unixODBC"
		fi
	fi
	use unicode && myconf="${myconf} --with-charset=utf-8"

	use mozldap && LDFLAGS=-L/usr/$(get_libdir)/mozldap
	econf \
		--disable-doxygen \
		--disable-html-docs \
		${myconf} || die "econf failed"
}

src_install () {
	einstall  || die "make install failed"
	dohtml -r site/*
	insinto /usr/share/doc/${PF}/examples
	doins src/examples/cpp/*.cpp
}
