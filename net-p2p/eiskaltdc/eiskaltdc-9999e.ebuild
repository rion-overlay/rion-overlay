# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: AntiXpucT$

EAPI=2

inherit qt4 subversion cmake-utils

DESCRIPTION="Qt based client for DirectConnect, fork of Valknut"
HOMEPAGE="https://sourceforge.net/projects/eiskaltdc/"
ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/experimental2"

KEYWORDS="~x86 ~amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/qt-gui:4
	>=dev-libs/libxml2-2.4.22
	>=net-p2p/dclib-0.3.23[ssl]
	dev-libs/openssl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README NEWS TODO
}
