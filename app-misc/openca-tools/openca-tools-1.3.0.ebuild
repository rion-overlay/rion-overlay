# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

WANT_AUTOMAKE="1.11"

inherit autotools-utils

DESCRIPTION="This package contains the prerequisites for installing OpenCA"
HOMEPAGE="http://www.openca.org"
SRC_URI="mirror://sourceforge/openca/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="debug static-libs"

DEPEND="dev-util/pkgconfig"
RDEPEND=">=dev-libs/openssl-0.9.7"

DOCS=(AUTHORS INSTALL  NEWS README  VERSION)
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure () {
	local myeconfargs=(
	--with-openca-user=openca
	--with-openca-group=openca )
	autotools-utils_src_configure
}

src_install () {
	autotools-utils_src_install

	rm -fr "${ED}"/usr/share/man || die
	doman docs/*.1
}

pkg_setup() {
		enewgroup openca
		enewuser openca -1 -1 /dev/null openca
}
