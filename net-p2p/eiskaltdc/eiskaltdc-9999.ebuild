# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: AntiXpucT$

#net-p2p/eiskaltdc/eiskaltdc-0.5.ebuild

EAPI=2
inherit autotools qt4
DESCRIPTION="Qt based client for DirectConnect, fork of Valknut"
HOMEPAGE="https://sourceforge.net/projects/eiskaltdc/"
if [[ "${PV}" = 9999 ]] ; then
	inherit subversion
	SRC_URI=""
	KEYWORDS=""
	ESVN_REPO_URI="https://${PN}.svn.sourceforge.net/svnroot/${PN}/trunk"
else
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
KEYWORDS="~x86 ~amd64"
fi;

LICENSE="GPL-3"

SLOT="0"
IUSE=""

RDEPEND="|| ( x11-libs/qt-gui:4 =x11-libs/qt-4.3*:4 )
	>=dev-libs/libxml2-2.4.22
	>=net-p2p/dclib-0.3.23
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		subversion_src_unpack
	else
		default
	fi;
}
src_prepare() {
		eautoreconf
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog README NEWS TODO
}
