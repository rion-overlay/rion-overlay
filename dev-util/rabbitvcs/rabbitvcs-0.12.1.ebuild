# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
NEED_PYTHON=2.5
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit gnome2-utils distutils

DESCRIPTION="Integrated version control support for Nautilus"
HOMEPAGE="http://rabbitvcs.org"
SRC_URI="http://rabbitvcs.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="diff"

DEPEND=""
RDEPEND="dev-python/nautilus-python
		dev-python/configobj
		dev-python/pyinotify
		dev-python/pygtk
		dev-python/dbus-python
		dev-python/pysvn
		diff? ( dev-util/meld )"

src_prepare() {
	distutils_src_prepare

	# we should not do gtk-update-icon-cache from setup script
	# we prefer portage for that
	sed 's/"install"/"fakeinstall"/' -i "${S}/setup.py" \
		|| die "Can't update setup script"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	distutils_pkg_postinst
	gnome2_icon_cache_update

	elog "You should restart nautilus to changes take effect:"
	elog "\$ nautilus -q && nautilus &"
	elog ""
	elog "Also you should really look at known issues page:"
	elog "http://wiki.rabbitvcs.org/wiki/support/known-issues"
}

pkg_postrm() {
	distutils_pkg_postrm
	gnome2_icon_cache_update
}
