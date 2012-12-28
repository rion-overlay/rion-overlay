# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

case "${PV}" in *.9999*) VCS=bzr ;; *) VCS="" ;; esac

inherit cmake-utils versionator ${VCS}

MPV=$(get_version_component_range 1-2 ${PV})
case "${PV}" in
	*.9999*)
		EBZR_REPO_URI="lp:cairo-dock-core"
		EBZR_BRANCH="${MPV}"
		;;
	*)
		SRC_URI="https://launchpad.net/cairo-dock-core/${MPV}/${PV}/+download/${P}.tar.gz"
		KEYWORDS="~amd64 ~x86"
		;;
esac

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="https://launchpad.net/cairo-dock-core/"

LICENSE="GPL-2"
SLOT="0"
IUSE="xext"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/libxml2
	x11-libs/cairo
	gnome-base/librsvg
	x11-libs/gtk+:3
	|| ( x11-libs/pangox-compat <x11-libs/pango-1.32 )
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
	sed -i -e '/set (libdir/aset (libdir "${CMAKE_INSTALL_LIBDIR}")' \
		CMakeLists.txt || die "sed failed"
	if [  -n "${VCS}" ]; then
		bzr_src_prepare
	else
		base_src_prepare
	fi
}
