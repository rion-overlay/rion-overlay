# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kchmviewer/kchmviewer-5.1.ebuild,v 1.1 2009/12/17 18:15:35 pva Exp $

EAPI="2"
KDE_REQUIRED="never"
inherit fdo-mime qt4 kde4-base

DESCRIPTION="KchmViewer is a feature rich chm file viewer, based on Qt."
HOMEPAGE="http://www.kchmviewer.net/"
SRC_URI="mirror://sourceforge/kchmviewer/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kde"

RDEPEND="dev-libs/chmlib
	>=x11-libs/qt-dbus-4.5:4
	>=x11-libs/qt-webkit-4.5:4
	!kde? ( >=x11-libs/qt-gui-4.5:4 )
	kde? ( >=kde-base/kdelibs-4.1
			!kde-base/okular[chm] )"
DEPEND="${RDEPEND}
		kde? ( dev-util/cmake )"

S=${WORKDIR}/build-${PV}

pkg_setup() {
	use kde && kde4-base_pkg_setup
}

src_prepare() {
	sed -e "s:KDE4_SERVICES_INSTALL_DIR:SERVICES_INSTALL_DIR:" \
			-i lib/kio-msits/CMakeLists.txt
	sed -e "s:KDE4_ICON_INSTALL_DIR:ICON_INSTALL_DIR:" \
		-e "s:KDE4_XDG_APPS_INSTALL_DIR:XDG_APPS_INSTALL_DIR:" \
			-i packages/CMakeLists.txt
	sed -e "s:KDE4_BIN_INSTALL_DIR:BIN_INSTALL_DIR:" \
			-i src/CMakeLists.txt
	sed -e "s:setUrl:load:" -i src/viewwindow_qtwebkit.cpp
	echo "CONFIG += ordered" >> kchmviewer.pro # parallel build fix #281954
}

src_configure() {
	if use kde; then
		kde4-base_src_configure
	else
		eqmake4
	fi
}

src_compile() {
	if use kde; then
		kde4-base_src_compile
	else
		emake || die
	fi
}

src_test() {
	einfo "No tests exist."
}

src_install() {
	if use kde; then
		kde4-base_src_install
	else
		dobin bin/kchmviewer || die "dobin kchmviewer failed"
		domenu packages/kchmviewer.desktop || die
		dodoc ChangeLog README || die
	fi
	insinto /usr/share/pixmaps/
	doins packages/kchmviewer.png || die
	dodoc DBUS-bindings FAQ || die
}

pkg_postinst() {
	use kde && kde4-base_pkg_postinst
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	use kde && kde4-base_pkg_postrm
	fdo-mime_desktop_database_update
}
