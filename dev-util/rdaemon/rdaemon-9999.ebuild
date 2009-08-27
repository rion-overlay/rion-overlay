# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 subversion

DESCRIPTION="Small xml-rpc demo app"
HOMEPAGE="http://code.google.com/p/rion-pg"
ESVN_REPO_URI="http://rion-pg.googlecode.com/svn/trunk/trunk/daemon"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core
	|| ( x11-libs/qt-sql[sqlite]
		 x11-libs/qt-sql[mysql] )
	dev-libs/qxmlrpc
	net-misc/wget"
RDEPEND="${DEPEND}"

src_compile() {
	eqmake4 rdaemon.pro
	emake || die "make failed"
}

src_install() {
	insinto /usr/bin
	dobin rdaemon
	dobin "${FILESDIR}/rdaemon-send"
}
