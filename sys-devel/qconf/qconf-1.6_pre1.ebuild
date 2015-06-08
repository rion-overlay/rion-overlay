# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.0-r2.ebuild,v 1.8 2008/03/15 11:30:02 corsair Exp $

EAPI=5

inherit multilib git-r3

DESCRIPTION="Qt ./configure generation util"
HOMEPAGE="http://delta.affinix.com/qconf/"
EGIT_COMMIT="4a9c329ba879d2acf27fabe9847b9bb54463e8ce"
EGIT_REPO_URI="git://github.com/psi-plus/qconf.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
#RESTRICT="test strip"

DEPEND="dev-qt/qtcore:4"
RDEPEND="${DEPEND}"

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr \
		--qtselect=4 \
		--extraconf=QMAKE_STRIP= || die "./configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
