# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"


DESCRIPTION="libcitadel contains common code of the components which make up the
Citadel system"
HOMEPAGE="http://www.citadel.org/"
SRC_URI="http://easyinstall.citadel.org/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="iconv +zlib"

DEPEND="sys-devel/libtool
		iconv? ( virtual/libiconv )
		zlib? ( sys-libs/zlib )"
RDEPEND="iconv? ( virtual/libiconv )
		zlib? ( sys-libs/zlib )"

src_configure() {
	econf \
		$(use_enable iconv) \
		$(use_with zlib) || die "econf failed"
}

src_install() {
	einstall || die "einstall failed"
}
