# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2 subversion

DESCRIPTION="A QT4 GUI for aria2 download manager"
HOMEPAGE="https://sourceforge.net/projects/karia2/"
ESVN_REPO_URI="https://karia2.svn.sourceforge.net/svnroot/karia2/trunk"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/aria2
	x11-libs/qt-gui
	x11-libs/qt-sql
	x11-libs/libXtst
	dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	for f in main.cpp norwegianwoodstyle.cpp abstractstorage.cpp karia2.cpp \
		ariaman.cpp sqlitecategorymodel.cpp preferencesdialog.cpp \
		sqlitetaskmodel.cpp; do
		sed -i -e \
		"s#\(app.\|qApp->\|QCoreApplication::\|QApplication::\)applicationDirPath()#QString\(\"/usr/share/${PN}\"\)#g" \
		"$f"
	done
	subversion_src_prepare
}

src_install() {
	dobin bin/${PN}
	insinto "${EPREFIX}"/usr/share/${PN}
	doins -r icons browser Resources images translations data doc sounds

	domenu data/karia2.desktop
	doicon Resources/karia2.png
}
