# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/kchmviewer/kchmviewer-4.0-r1.ebuild,v 1.3 2009/04/06 11:36:00 scarabeus Exp $

EAPI="2"
NEED_KDE="none"
inherit fdo-mime qt4 kde4-base

MY_P="${PN}-${PV/_beta/beta}"

DESCRIPTION="KchmViewer is a feature rich chm file viewer, based on Qt."
HOMEPAGE="http://www.kchmviewer.net/"
SRC_URI="mirror://sourceforge/kchmviewer/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kde"

RDEPEND="dev-libs/chmlib
	x11-libs/qt-dbus:4
	x11-libs/qt-webkit:4
	!kde? ( x11-libs/qt-gui:4 )
	kde? ( >=kde-base/kdelibs-4.1
			!kde-base/okular[chm] )"
DEPEND="${RDEPEND}
		kde? ( dev-util/cmake )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use kde; then
		kde4-base_pkg_setup
	fi
}

src_prepare() {
	sed -e "s:KDE4_SERVICES_INSTALL_DIR:SERVICES_INSTALL_DIR:" \
			-i lib/kio-msits/CMakeLists.txt
	sed "s:KDE4_ICON_INSTALL_DIR:ICON_INSTALL_DIR:" -i src/kde/CMakeLists.txt
	sed -e "s:KDE4_BIN_INSTALL_DIR:BIN_INSTALL_DIR:" \
		-e "s:KDE4_XDG_APPS_INSTALL_DIR:XDG_APPS_INSTALL_DIR:" \
			-i src/CMakeLists.txt
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
		# install icons in hicolor since it's fallback in kde irrespectively of
		# ICON_INSTALL_DIR (this is really strange...)
		for size in 48 64 128; do
			insinto /usr/share/icons/hicolor/${size}x${size}/apps && \
				newins src/kde/cr${size}-app-kchmviewer.png kchmviewer.png || die
		done
		kde4-base_src_install
	else
		dobin bin/kchmviewer || die "dobin kchmviewer failed"
		newmenu src/kde/kchmviewer.desktop kchmviewer.desktop
		for size in 48 64 128; do
			insinto /usr/share/icons/hicolor/${size}x${size}/apps && \
				newins src/kde/cr${size}-app-kchmviewer.png kchmviewer.png || die
		done
		dodoc ChangeLog README || die
	fi
	dodoc "${S}"/{DBUS-bindings,FAQ} || die
}

pkg_postinst() {
	use kde && kde4-base_pkg_postinst
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	use kde && kde4-base_pkg_postrm
	fdo-mime_desktop_database_update
}
