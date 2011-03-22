# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools confutils

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="http://www.gnu.org/software/commoncpp"
SRC_URI="http://www.gnutelephony.org/dist/tarballs/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs socks cxx debug openssl gnutls"

DEPEND="dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	${RDEPEND}"

RDEPEND="openssl? ( dev-libs/openssl )
	gnutls? ( net-libs/gnutls )"

pkg_setup() {
	confutils_use_conflict openssl gnutls
}

src_prepare() {
	eautoreconf
	epatch "${FILESDIR}"/disable_rtf_gen_doxy.patch
}

src_configure() {

	local myconf=""
	if use !openssl && use !gnutls; then
		myconf=" --with-sslstack=nossl "
	fi

	if use openssl; then
		myconf=" --with-sslstack=ssl "
	fi

	if use gnutls; then
		myconf=" --with-sslstack=gnu "
	fi

	econf \
	$(use_enable  static-libs static) \
	$(use_enable  socks) \
	$(use_enable  cxx stdcpp) \
	$(use_enable  debug) \
	${myconf} \
	--enable-atomics \
	--with-pkg-config || die "econf failed"
}

src_test() {
	emake check  || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		emake DESTDIR="${D}" doxy || die "documentaion created failed"
		dohtml doc/html/*
	fi

	find "${ED}"/$(get_libdir) -name \*.la -delete
	find "${ED}"/usr/$(get_libdir) -name \*.la -delete

	dodoc README  NEWS SUPPORT ChangeLog

	dodoc AUTHORS README  NEWS SUPPORT ChangeLog
}
