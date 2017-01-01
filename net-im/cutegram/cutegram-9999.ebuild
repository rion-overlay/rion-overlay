# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils git-r3

DESCRIPTION="A different telegram client from Aseman team forked from Sigram by Sialan Labs. "
HOMEPAGE="http://aseman.co/en/products/cutegram/"
EGIT_REPO_URI="https://github.com/Aseman-Land/Cutegram.git"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=net-misc/TelegramQML-9999
	dev-qt/qtwebkit:5
	dev-qt/qtmultimedia:5
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtpositioning:5[qml]
	net-misc/aseman-qt-tools
"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install(){
	emake INSTALL_ROOT="${D}" install
}
