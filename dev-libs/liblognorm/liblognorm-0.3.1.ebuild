# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils

DSCRIPTION="liblognorm - a fast samples-based log normalization library"
HOMEPAGE="http://www.liblognorm.com"
SRC_URI="http://www.liblognorm.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="debug static-libs"

DEPEND="
	dev-libs/libestr
	dev-libs/libee"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_compile() {
	emake -j1
}
