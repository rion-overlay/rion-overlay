# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

NEED_PYTHON=2.5

inherit eutils python

DESCRIPTION="Consolidated menu for gnome"
HOMEPAGE="https://launchpad.net/gnomenu"
SRC_URI="http://launchpad.net/gnomenu/trunk/2.6/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome +applet"

DEPEND=""
RDEPEND="dev-python/pyxdg
	dev-python/pycairo
	dev-python/pygtk
	dev-python/gconf-python
	applet? ( gnome-extra/gnomenu[gnome] )
	gnome? (
		applet? ( dev-python/gnome-applets-python )
		gnome-base/gnome-menus
	)
	dev-python/numpy
	dev-python/python-xlib"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/gnomenu-2.5-libdir.patch"
	sed "s/\(LIBDIR = .*\)lib/\1$(get_libdir)/" -i Makefile
	sed "s,'/lib/gnomenu/','/lib64/gnomenu/'," -i setup.py
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/gnomenu
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gnomenu
}
