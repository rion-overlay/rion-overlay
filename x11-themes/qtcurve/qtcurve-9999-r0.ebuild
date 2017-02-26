# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_REQUIRED="optional"
KDE_AUTODEPS=false
KDE_DEBUG=false
KDE_HANDBOOK=false # needed for kde5.eclass, but misinterpreted by kde4-base.eclass
inherit kde5 cmake-multilib

DESCRIPTION="A set of widget styles for Qt and GTK2"
HOMEPAGE="https://projects.kde.org/projects/playground/base/qtcurve"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eegorov/qtcurve.git"
	EGIT_COMMIT=c1543d2f27e5ac6f6424537a53e3764233967e68
	KEYWORDS=""
else
	SRC_URI="https://github.com/QtCurve/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/QtCurve/${PN}/commit/69047935dd4a9549d238cbc457e9c3cfa37386ae.patch -> ${P}-old_config_file.patch"
	KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+X gtk kf5 nls +qt4 qt5 windeco"
REQUIRED_USE="gtk? ( X )
	kf5? ( qt5 )
	|| ( gtk qt4 qt5 )"

RDEPEND="X? ( x11-libs/libxcb[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-image[${MULTILIB_USEDEP}] )
	gtk? ( x11-libs/gtk+:2[${MULTILIB_USEDEP}] )
	qt4? ( dev-qt/qtdbus:4[${MULTILIB_USEDEP}]
		dev-qt/qtgui:4[${MULTILIB_USEDEP}]
		dev-qt/qtsvg:4[${MULTILIB_USEDEP}] )
	qt5? ( dev-qt/qtdeclarative:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		X? ( dev-qt/qtdbus:5
			dev-qt/qtx11extras:5 ) )
	kf5? ( $(add_frameworks_dep extra-cmake-modules)
		$(add_frameworks_dep karchive)
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kconfigwidgets)
		$(add_frameworks_dep ki18n)
		$(add_frameworks_dep kdelibs4support)
		$(add_frameworks_dep kio)
		$(add_frameworks_dep kwidgetsaddons)
		$(add_frameworks_dep kxmlgui) )
	!x11-themes/gtk-engines-qtcurve"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog.md README.md TODO.md )

[[ ${PV} == *9999* ]] || PATCHES=( "${DISTDIR}/${P}-old_config_file.patch" )
PATCHES+=(
	"${FILESDIR}/qtcurve-remove-filedialog-hooks.patch"
)

pkg_pretend() {
	if [[ "$(multilib_get_enabled_abis)" != "${DEFAULT_ABI}" ]]; then
		use qt5 && elog "Qt5 is not (yet) multilib-aware, qtcurve will be built for Qt5 with native ABI only"
		use kf5 && elog "KF5 is not (yet) multilib-aware, qtcurve will be built for KF5 with native ABI only"
	fi
}

pkg_setup() {
	# bug #498776
	if ! version_is_at_least 4.7 $(gcc-version) ; then
		append-cxxflags -Doverride=
	fi
}

multilib_src_configure() {
	local mycmakeargs

	if multilib_is_native_abi; then
		mycmakeargs=(
			-DQTC_QT4_ENABLE_KDE=OFF
			-DQTC_QT4_ENABLE_KWIN=OFF
			-DENABLE_QT5=$(usex qt5)
			-QTC_QT5_ENABLE_KDE=$(usex kf5)
		)
	else
		mycmakeargs=(
			-DQTC_QT4_ENABLE_KDE=OFF
			-DQTC_QT4_ENABLE_KWIN=OFF
			-DQTC_QT5_ENABLE_KDE=OFF
			-DENABLE_QT5=OFF
		)
	fi

	mycmakeargs+=(
		-DLIB_INSTALL_DIR=/usr/$(get_libdir)
		-DENABLE_GTK2=$(usex gtk)
		-DENABLE_QT4=$(usex qt4)
		-DQTC_ENABLE_X11=$(usex X)
		$(is_final_abi && usex nls && echo -DQTC_INSTALL_PO=ON || echo -DQTC_INSTALL_PO=OFF)
	)
	cmake-utils_src_configure
}
