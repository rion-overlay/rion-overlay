# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils bzr

EBZR_REPO_URI="lp:cairo-dock-core"
EBZR_BRANCH="${PV%.*}"

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="https://launchpad.net/cairo-dock-core/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="xcomposite"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/libxml2
	x11-libs/cairo
	x11-libs/gtk+:2
	gnome-base/librsvg
	x11-libs/gtkglext
	x11-libs/libXrender
	net-misc/curl
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

pkg_postinst() {
	ewarn "THIS IS A LIVE EBUILD, SO YOU KNOW THE RISKS !"
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "Please report all bugs to #gentoo-desktop-effects"
	einfo "Thank you on behalf of the Gentoo Desktop-Effects team"
}
