# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/gcdemu/gcdemu-1.1.0.ebuild,v 1.1 2008/08/03 21:15:39 vanquirius Exp $

inherit gnome2

DESCRIPTION="gCDEmu is a GNOME applet for controlling CDEmu daemon"
HOMEPAGE="http://cdemu.org/"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.4
	>=dev-python/pygtk-2.6
	>=dev-python/pygobject-2.6
	>=dev-python/gnome-python-2.6
	>=dev-python/gnome-python-desktop-2.6
	>=dev-python/dbus-python-0.71
	>=app-cdr/cdemud-1.2.0
	dev-python/notify-python"
DEPEND="${RDEPEND}
	dev-util/intltool"

S="${WORKDIR}/${PN}-${PV}"

pkg_postinst() {
	einfo "For notifications, emerge dev-python/notify-python"
}
