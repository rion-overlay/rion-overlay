# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit toolchain-funcs

DESCRIPTION="OpenVZ VPS disk quota utility"
HOMEPAGE="http://openvz.org/download/utils/vzquota/"
SRC_URI="http://download.openvz.org/utils/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	sed -e 's,$(INSTALL) -s -m,$(INSTALL) -m,' \
		-e 's:$(CC) $(CFLAGS) -o:$(CC) $(CFLAGS) $(LDFLAGS) -o:' \
		-e 's:-Werror ::' \
			-i "${S}/src/Makefile" -i -i "${S}/man/Makefile" || die
}

src_compile() {
	tc-export CC
	emake
}

src_install() {
INSTALL="$(which install)" 	emake DESTDIR="${D}" install
	keepdir /var/vzquota
}
