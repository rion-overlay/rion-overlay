# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca/qca-2.0.0-r2.ebuild,v 1.8 2008/03/15 11:30:02 corsair Exp $

EAPI="4"

inherit subversion

DESCRIPTION="Qt ./configure generation util"
HOMEPAGE="http://delta.affinix.com/qconf/"
ESVN_REPO_URI="https://delta.affinix.com/svn/trunk/qconf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
#RESTRICT="test strip"

DEPEND="x11-libs/qt-core"
RDEPEND="${DEPEND}"

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr \
		--qtdir=/usr/$(get_libdir)/ || die "./configure failed"
	"${EPREFIX}"/usr/bin/qmake \
		QTDIR="${EPREFIX}"/usr/$(get_libdir) \
			QMAKE="${EPREFIX}"/usr/bin/qmake \
			QMAKE_CC="$(tc-getCC)" \
			QMAKE_CXX="$(tc-getCXX)" \
			QMAKE_LINK="$(tc-getCXX)" \
			QMAKE_CXXFLAGS_RELEASE="${CXXFLAGS}" \
			QMAKE_CXXFLAGS_DEBUG="${CXXFLAGS}" \
			QMAKE_LFLAGS_RELEASE="${LDFLAGS}" \
			QMAKE_LFLAGS_DEBUG="${LDFLAGS}" \
			QMAKE_LIBDIR_QT="${EPREFIX}"/usr/$(get_libdir)/qt4 \
			QMAKE_LIBDIR_X11="${EPREFIX}"/usr/$(get_libdir) \
			QMAKE_LIBDIR_OPENGL="${EPREFIX}"/usr/$(get_libdir) \
			QMAKE_STRIP= || die "qmake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
