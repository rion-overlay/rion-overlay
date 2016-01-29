# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.0-r2.ebuild,v 1.8 2008/03/15 11:30:02 corsair Exp $

EAPI=5

inherit multilib git-r3

DESCRIPTION="Qt ./configure generation util"
HOMEPAGE="http://delta.affinix.com/qconf/"
EGIT_REPO_URI="git://github.com/psi-plus/qconf.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="qt4 qt5"
#RESTRICT="test strip"

DEPEND="
	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="^^ ( qt4 qt5 )"

src_configure() {
	use qt4 && QTVERSION=4
	use qt5 && QTVERSION=5
	./configure \
	--prefix="${EPREFIX}"/usr \
	--qtselect="${QTVERSION}" || die "./configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
