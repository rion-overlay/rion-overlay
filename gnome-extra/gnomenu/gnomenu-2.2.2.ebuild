# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Consolidated menu for gnome"
HOMEPAGE="https://launchpad.net/gnomenu"
SRC_URI="http://launchpad.net/gnomenu/trunk/2.2/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/python-2.5"
RDEPEND="${DEPEND}
	>=dev-python/pyxdg-0.17-r2
	dev-python/pycairo
	dev-python/python-xlib
	gnome-extra/deskbar-applet
	dev-python/gconf-python"

src_install() {
	cd "${WORKDIR}/${PN}"
	make DESTDIR="${D}" install || die "make install failed"
}
