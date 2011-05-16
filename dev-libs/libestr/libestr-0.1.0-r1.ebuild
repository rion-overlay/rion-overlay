# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="library for some string essentials"
HOMEPAGE="http://libestr.adiscon.com"
SRC_URI="http://libestr.adiscon.com/files/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=(ChangeLog)
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	eautoreconf
}
