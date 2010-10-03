# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="lightweigt program for using per window keyboard layout"
HOMEPAGE="http://github.com/qnikst/kbdd"
SRC_URI="http://github.com/qnikst/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/glib
x11-libs/libX11"
RDEPEND="${DEPEND}"
HASH="faa9d88"

S="${WORKDIR}/qnikst-kbdd-${HASH}"

src_compile() {
emake
}

src_install() {
dodoc README CHANGES LICENSE
#dolib.so libkbdd.so
dobin kbdd
}
