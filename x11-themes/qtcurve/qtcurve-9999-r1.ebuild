# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_AUTODEPS=false
inherit kde5 cmake-multilib git-r3

DESCRIPTION="Widget styles for Qt and GTK2"
HOMEPAGE="https://cgit.kde.org/qtcurve.git"

EGIT_REPO_URI="https://github.com/eegorov/qtcurve.git"
KEYWORDS=""

LICENSE="LGPL-2+"
SLOT="0"
IUSE="+X gtk plasma nls qt5 test"

REQUIRED_USE="gtk? ( X )
	|| ( gtk qt5 )
	plasma? ( qt5 )
"
COMMON_DEPEND="
	gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	qt5? (
		$(add_qt_dep qtdbus)
		$(add_qt_dep qtgui)
		$(add_qt_dep qtsvg)
		$(add_qt_dep qtwidgets)
		$(add_qt_dep qtx11extras)
	)
	plasma? (
		$(add_frameworks_dep frameworkintegration)
		$(add_frameworks_dep karchive)
		$(add_frameworks_dep kcompletion)
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep kcoreaddons)
		$(add_frameworks_dep kdelibs4support)
		$(add_frameworks_dep kguiaddons)
		$(add_frameworks_dep ki18n)
		$(add_frameworks_dep kiconthemes)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep kwindowsystem)
		$(add_frameworks_dep kxmlgui)
		$(add_qt_dep qtprintsupport)
	)
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libxcb[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-image[${MULTILIB_USEDEP}]
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="${COMMON_DEPEND}
	!x11-themes/gtk-engines-qtcurve
"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

pkg_pretend() {
	if [[ "$(multilib_get_enabled_abis)" != "${DEFAULT_ABI}" ]]; then
		use qt5 && elog "Qt5 is not (yet) multilib-aware, qtcurve will be built for Qt5 with native ABI only"
		use plasma && elog "KF5 is not (yet) multilib-aware, qtcurve will be built for KF5 with native ABI only"
	fi
}

multilib_src_configure() {
	local mycmakeargs

	if multilib_is_native_abi; then
		mycmakeargs=(
			-DENABLE_QT5=$(usex qt5)
			-QTC_QT5_ENABLE_KDE=$(usex plasma)
		)
	else
		mycmakeargs=(
			-DENABLE_QT5=OFF
			-DQTC_QT5_ENABLE_KDE=OFF
		)
	fi

	mycmakeargs+=(
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		-DQTC_QT4_ENABLE_KDE=OFF
		-DQTC_QT4_ENABLE_KWIN=OFF
		-DQTC_KDE4_DEFAULT_HOME=ON
		-DENABLE_GTK2=$(usex gtk)
		-DENABLE_QT4=OFF
		-DENABLE_TEST="$(usex test)"
		-DQTC_ENABLE_X11=$(usex X)
		$(is_final_abi && usex nls && echo -DQTC_INSTALL_PO=ON || echo -DQTC_INSTALL_PO=OFF)
	)
	cmake-utils_src_configure
}
