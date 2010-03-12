# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils

DESCRIPTION="NIS plugin 389 (FDS) server"
HOMEPAGE="https://fedorahosted.org/slapi-nis"
SRC_URI="https://fedorahosted.org/releases/s/l/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tcpd tirpc"

COMMON_DEPEND="net-nds/389-ds-base
		tirpc? ( net-libs/libtirpc )
		tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	eautoreconf
}
src_configure() {

	econf \
	--with-server=dirsrv \
	$(use_with tirpc) \
	$(use_with tcpd tcp-wrappers) || die
}

src_install() {
	emake DESTDIR="${D}"  install || die

	dodoc  "${S}"/doc/*.{txt,ldif}

	dodoc NEWS README STATUS
}
