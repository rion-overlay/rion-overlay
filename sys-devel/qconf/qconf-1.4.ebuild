# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.0-r2.ebuild,v 1.8 2008/03/15 11:30:02 corsair Exp $

EAPI="1"

inherit eutils multilib qt4

DESCRIPTION="Qt configure generation util"
HOMEPAGE="http://delta.affinix.com/qconf/"
SRC_URI="http://delta.affinix.com/download/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="debug doc examples"
RESTRICT="test"

DEPEND="
	|| ( x11-libs/qt-core:4
		=x11-libs/qt-4.3* )"
RDEPEND="${DEPEND}"

src_compile() {
	./configure \
		--prefix=/usr \
		--qtdir=/usr \
		|| die "configure failed"

	#eqmake4 ${PN}.pro
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc README TODO || die "dodoc failed."
}
