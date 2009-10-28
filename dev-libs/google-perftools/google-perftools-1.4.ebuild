# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="Fast, multi-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/google-perftools/"
SRC_URI="http://google-perftools.googlecode.com/files/"${PN}"-"${PV}".tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="minimal"

DEPEND="amd64? ( >=sys-libs/libunwind-0.99 ) "
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	local myconf=""
	use amd64 && myconf="--enable-frame-pointers"

	econf 	$(use_enable minimal) \
			${myconf} || die "Econf failed"
}

src_install() {

	emake DESTDIR="${D}" install || die "Install failed"
}
