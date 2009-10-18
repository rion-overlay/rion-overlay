# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.0-r2.ebuild,v 1.8 2008/03/15 11:30:02 corsair Exp $

EAPI="2"

inherit qt4 subversion

DESCRIPTION="Qt configure generation util"
HOMEPAGE="http://delta.affinix.com/qconf/"
ESVN_REPO_URI="https://delta.affinix.com/svn/trunk/qconf"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS=""
IUSE=""
RESTRICT="test strip"

DEPEND="x11-libs/qt-core:4"
RDEPEND="${DEPEND}"

src_configure() {
	./configure \
		--prefix=/usr \
		--qtdir=/usr \
		|| die "configure failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
}
