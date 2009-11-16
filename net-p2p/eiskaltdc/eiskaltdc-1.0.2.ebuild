# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: AntiXpucT$

EAPI=2

inherit autotools qt4

DESCRIPTION="Qt based client for DirectConnect, fork of Valknut"
HOMEPAGE="https://sourceforge.net/projects/eiskaltdc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug"

RDEPEND="|| ( x11-libs/qt-gui:4 =x11-libs/qt-4.3*:4 )
	>=dev-libs/libxml2-2.4.22
	>=net-p2p/dclib-0.3.23[ssl]
	dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
		eautoreconf
}

src_configure() {
	local myconf=""
	use debug && myconf="--enable-warning --enable-debug "
	use !debug $$ myconf="--disable-debug"

	econf $myconf || die "econf failed"
}
src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README NEWS TODO
}
