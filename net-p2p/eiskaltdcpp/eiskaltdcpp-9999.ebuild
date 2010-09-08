# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/eiskaltdcpp/eiskaltdcpp-9999.ebuild,v 1.12 2010/09/05 05:03:13 pva Exp $

EAPI="2"

LANGS="be bg en es fr hu pl ru sr uk"
CMAKE_MIN_VERSION="2.6.0"
inherit qt4-r2 cmake-utils subversion

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
HOMEPAGE="http://eiskaltdc.googlecode.com/"
ESVN_REPO_URI="http://${PN%pp}.googlecode.com/svn/branches/trunk/"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="dbus examples -gnome -gtk -javascript kde lua +qt4 spell upnp"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	>=dev-libs/openssl-0.9.8
	virtual/libiconv
	sys-devel/gettext
	lua? ( >=dev-lang/lua-5.1 )
	gtk? (
		x11-libs/pango
		>=x11-libs/gtk+-2.10:2
		>=dev-libs/glib-2.10:2
		>=gnome-base/libglade-2.4:2.0
		>=x11-libs/libnotify-0.4.1
		gnome? ( gnome-base/libgnome )
	)
	qt4? (
		>=x11-libs/qt-gui-4.4.0:4[dbus?]
		javascript? (
			x11-libs/qt-script
			x11-libs/qtscriptgenerator
		)
		kde? (
			kde-base/oxygen-icons
			>=x11-libs/qt-gui-4.6.0:4
		)
		spell? ( app-text/aspell )
	)
	upnp? ( net-misc/miniupnpc )
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.34.1
	dev-util/pkgconfig
"
DOCS="AUTHORS ChangeLog.txt"

pkg_setup() {
	use gtk && ewarn "GTK UI is very experimental, only Qt4 frontend is stable."
}

src_configure() {
	# linguas
	local langs
	for x in ${LANGS}; do
		use linguas_${x} && langs+=" ${x}"
	done

	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-Dlinguas="${langs}"
		$(cmake-utils_use '' lua LUA_SCRIPT)
		$(cmake-utils_use '' dbus DBUS_NOTIFY)
		$(cmake-utils_use_use javascript JS)
		$(cmake-utils_use_use kde ICON_THEME)
		$(cmake-utils_use_use spell ASPELL)
		$(cmake-utils_use_use qt4 QT)
		$(cmake-utils_use_use upnp MINIUPNP)
		$(cmake-utils_use '' upnp LOCAL_MINIUPNP)
		$(cmake-utils_use_use gtk GTK)
		$(cmake-utils_use_use gnome LIBGNOME2)
		$(cmake-utils_use_with examples EXAMPLES)
		"-DUSE_WT=OFF"
	)
	cmake-utils_src_configure
}
