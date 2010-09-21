# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools

DESCRIPTION="Portable C++ runtime for threads and sockets"
HOMEPAGE="http://www.gnu.org/software/commoncpp"
SRC_URI="http://www.gnutelephony.org/dist/tarballs/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs socks +cxx"

DEPEND="dev-util/pkgconfig
		doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	eautoreconf
	epatch "${FILESDIR}"/disable_rtf_gen_doxy.patch
}

src_configure() {
	
	econf \
	$(use_enable  static-libs static) \
	$(use_enable  socks) \
	$(use_enable  cxx stdcpp) \
	--enable-atomics \
	--with-pkg-config || die "econf failed"
}

src_test() {
	cd "${S}"/test
	emake testing || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use doc; then
		emake DESTDIR="${D}" doxy || die "documentaion created failed"
		dohtml doc/html/*
	fi
	dodoc README  NEWS SUPPORT ChangeLog

	dodoc AUTHORS README  NEWS SUPPORT ChangeLog
}
