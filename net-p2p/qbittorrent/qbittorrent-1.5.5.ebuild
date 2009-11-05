# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-1.5.3.ebuild,v 1.1 2009/09/30 22:49:40 yngwin Exp $

EAPI="2"
inherit eutils qt4 multilib

MY_P="${P/_/}"
DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# boost version so that we always have thread support
DEPEND=" x11-libs/qt-gui:4
	>=net-libs/rb_libtorrent-0.14.6
	>=dev-libs/boost-1.34.1
	dev-libs/zziplib
	net-misc/curl
	dev-cpp/commoncpp2"
RDEPEND="${DEPEND}
	>=dev-lang/python-2.3"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Respect LDFLAGS
	sed -i -e 's/-Wl,--as-needed/$(LDFLAGS)/g' src/src.pro
	qt4_src_prepare
}

src_configure() {
	# econf fails, since this uses qconf
	./configure --prefix=/usr --qtdir=/usr || die "configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc AUTHORS Changelog NEWS README TODO
}
