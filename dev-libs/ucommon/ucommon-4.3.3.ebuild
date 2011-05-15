# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
AUTOTOOLS_IN_SOURCE_BUILD=1
WANT_AUTOMAKE=1.10

inherit autotools-utils confutils

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="http://www.gnu.org/software/commoncpp"
SRC_URI="http://www.gnutelephony.org/dist/tarballs/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs socks +cxx debug ssl gnutls"

DEPEND="dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

RDEPEND="ssl? ( dev-libs/openssl )
	gnutls? ( net-libs/gnutls )"

DOCS=(README  NEWS SUPPORT ChangeLog AUTHORS)
PATCH=("${FILESDIR}"/disable_rtf_gen_doxy.patch)

src_prepare() {
	eautoreconf
}

src_configure() {

	local myconf=""
	if use !ssl && use !gnutls; then
		myconf=" --with-sslstack=nossl "
	fi

	if use ssl; then
		myconf=" --with-sslstack=ssl "
	fi

	if use gnutls; then
		myconf=" --with-sslstack=gnu "
	fi

	local myeconfargs=(
	$(use_enable  socks) \
	$(use_enable  cxx stdcpp) \
	${myconf} \
	--enable-atomics \
	--with-pkg-config \
	--enable-posix-timers \
	)
	autotools-utils_src_configure
}

src_test() {
	emake check
}

src_install() {

	autotools-utils_src_install
	if use doc; then
		emake DESTDIR="${D}" doxy
		dohtml doc/html/*
	fi
}