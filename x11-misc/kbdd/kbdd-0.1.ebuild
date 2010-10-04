# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Very simple layout switcher"
HOMEPAGE="http://github.com/qnikst/kbdd"
SRC_URI="http://github.com/qnikst/${PN}/tarball/v${PV} -> ${P}.tar.gz"
HASH="faa9d88"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/glib
		x11-libs/libX11"
RDEPEND="${DEPEND}"

S="${WORKDIR}/qnikst-kbdd-${HASH}"

src_compile() {
	emake || die "make failed"
}

src_install() {
	dodoc README CHANGES LICENSE || die "Installing documentation failed"
	#dolib.so libkbdd.so || die "Installing shared lib failed"
	dobin kbdd || die "Installing executable failed"
}
