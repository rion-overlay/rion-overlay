# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

inherit eutils python

DESCRIPTION="Consolidated menu for gnome"
HOMEPAGE="https://launchpad.net/gnomenu"
SRC_URI="http://launchpad.net/gnomenu/trunk/2.9/+download/${P}.tar.gz"

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
	sed -i -e "s/\(LIBDIR = .*\)lib/\1$(get_libdir)/" Makefile || die "sed failed"
	sed -i -e  "s,'/lib/gnomenu/','/$(get_libdir)/gnomenu/'," \
		-e "/INSTALL_PREFIX = '/aINSTALL_PREFIX='${EROOT}/usr'" \
		setup.py || die "sed failed";
}

src_install() {
	install() {
		emake DESTDIR="${ED}" install || die "emake"
	}
	python_execute_function install
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/gnomenu
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/gnomenu
}
