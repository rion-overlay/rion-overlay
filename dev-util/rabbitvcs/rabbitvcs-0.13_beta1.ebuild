# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils distutils

DESCRIPTION="Integrated version control support for your desktop"
HOMEPAGE="http://rabbitvcs.org"

MY_PV=${PV/_/.}
FRONTENDS="cli gedit nautilus thunar"
IUSE="diff spell ${FRONTENDS}"
SRC_URI="http://rabbitvcs.googlecode.com/files/${PN}-core-${MY_PV}.tar.gz"
for fe in $FRONTENDS; do 
	SRC_URI="${SRC_URI} ${fe}? (
	http://rabbitvcs.googlecode.com/files/${PN}-${fe}-${MY_PV}.tar.gz )"
done
S="${WORKDIR}/${PN}-core-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-python/pygtk
		dev-python/pygobject
		dev-python/pysvn
		dev-python/configobj"

PDEPEND="diff? ( dev-util/meld )
		gedit? ( app-editors/gedit )
		nautilus? ( dev-python/nautilus-python
			dev-python/dbus-python )
		thunar? ( dev-python/thunarx-python
			dev-python/dbus-python )
		spell? ( dev-python/gtkspell-python )"

src_unpack() {
	distutils_src_unpack

	# we should not do gtk-update-icon-cache from setup script
	# we prefer portage for that
	sed 's/"install"/"fakeinstall"/' -i "${S}/setup.py" \
		|| die "Can't update setup script"
}

src_install() {
	distutils_src_install
	use cli && dobin "${WORKDIR}/${PN}-cli-${MY_PV}/${PN}"
	use gedit && {
		insinto /usr/$(get_libdir)/gedit-2/plugins
		doins "${WORKDIR}/${PN}-gedit-${MY_PV}/rabbitvcs-plugin.py"
		doins "${WORKDIR}/${PN}-gedit-${MY_PV}/rabbitvcs.gedit-plugin"
	}
	use nautilus && {
		insinto "/usr/$(get_libdir)/nautilus/extensions-2.0/python"
		doins "${WORKDIR}/${PN}-nautilus-${MY_PV}/RabbitVCS.py"
	}
	use thunar && {
		has_version '>=xfce-base/thunar-1.1.0' && tv=2 || tv=1
		insinto "/usr/$(get_libdir)/thunarx-${tv}/python"
		doins "${WORKDIR}/${PN}-thunar-${MY_PV}/RabbitVCS.py"
	}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update

	elog "You should restart file manager to changes take effect:"
	use nautilus && elog "\$ nautilus -q && nautilus &"
	use thunar && elog "\$ thunar -q && thunar &"
	elog ""
	elog "Also you should really look at known issues page:"
	elog "http://wiki.rabbitvcs.org/wiki/support/known-issues"
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
