# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit bzr

DESCRIPTION="consolidated menu for gnome"
HOMEPAGE="https://launchpad.net/gnomenu"
EBZR_REPO_URI="lp:gnomenu"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/python-2.5"
RDEPEND="${DEPEND}
	>=dev-python/pyxdg-0.17
	dev-python/pycairo
	dev-python/python-xlib
	gnome-extra/deskbar-applet
	dev-python/gconf-python"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

