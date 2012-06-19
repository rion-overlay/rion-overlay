# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="https://launchpad.net/cairo-dock-core/"
SRC_URI="https://launchpad.net/cairo-dock-core/3.0/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xext"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/libxml2
	x11-libs/cairo
	gnome-base/librsvg
	x11-libs/pango
	virtual/glu
	x11-libs/libXrender
	net-misc/curl
	xext? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	sed -i -e '/set (libdir/aset (libdir "${CMAKE_INSTALL_LIBDIR}")' CMakeLists.txt
	base_src_prepare
}
