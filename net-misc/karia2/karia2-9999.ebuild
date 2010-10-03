# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2 subversion

DESCRIPTION="A QT4 GUI for aria2 download manager"
HOMEPAGE="https://sourceforge.net/projects/karia2/"
ESVN_REPO_URI="https://karia2.svn.sourceforge.net/svnroot/karia2/trunk"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-misc/aria2
	x11-libs/qt-gui
	x11-libs/qt-sql
	x11-libs/libXtst
	dev-libs/openssl"
RDEPEND="${DEPEND}"

src_install() {
	dobin bin/${PN}
	insinto /usr/share/${PN}
	doins -r icons browser Resources images translations data doc sounds
}
