# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Consolidated menu for gnome"
HOMEPAGE="https://launchpad.net/gnomenu"
SRC_URI="http://launchpad.net/gnomenu/trunk/2.5/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-python/pyxdg-0.17-r2
	dev-python/pycairo
	dev-python/python-xlib
	gnome-extra/deskbar-applet
	dev-python/gconf-python"

S="${WORKDIR}/${PN}"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
