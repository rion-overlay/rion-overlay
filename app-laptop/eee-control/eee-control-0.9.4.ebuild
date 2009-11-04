# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

WANT_PYTHON="2.6"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils python

DESCRIPTION="Tools to manage Hotkeys, WLAN, Bluetooth and other features of an Asus EeePC."
HOMEPAGE="http://greg.geekmind.org/eee-control/"
SRC_URI="http://greg.geekmind.org/eee-control/src/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="mirror"
IUSE="gnome gtk kde +xosd"

DEPEND=""
RDEPEND="gtk? ( dev-python/pygtk dev-python/gconf-python )
	gnome? ( gnome-extra/gnome-power-manager )
	xosd? ( x11-libs/xosd )
	dev-python/notify-python
	dev-python/dbus-python
	>=sys-apps/i2c-tools-3.0.2[python]
	kde? ( x11-themes/gtk-engines-qt )"

DOCS="doc/README"

python_need_rebuild

src_prepare() {

	epatch "${FILESDIR}/gentoo-dbus-config.patch" || die "Patching DBus config failed."

	distutils_src_prepare
}

src_install() {

	distutils_src_install

	newinitd  "${FILESDIR}/gentooinit" eee-control || die "Inserting init script failed."

	rm -fr "${D}/usr/src" || die "Kernel module removed failed"
	einfo "Kernel module removed"

	newicon "${D}"/usr/share/eee-control/eee-icon.png

#	make_desktop_entry
}

