# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: AntiXpucT$

EAPI=2

inherit autotools qt4 subversion

DESCRIPTION="Qt based client for DirectConnect, fork of Valknut"
HOMEPAGE="https://sourceforge.net/projects/eiskaltdc/"
SRC_URI=""
KEYWORDS=""
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="|| ( x11-libs/qt-gui:4 =x11-libs/qt-4.3*:4 )
	>=dev-libs/libxml2-2.4.22
	>=net-p2p/dclib-0.3.23
	dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
		subversion_src_unpack
}
src_prepare() {
		eautoreconf
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README NEWS TODO
}
