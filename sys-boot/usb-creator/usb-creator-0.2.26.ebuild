# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.*"
inherit distutils

DESCRIPTION="create a startup disk using a CD or disc image"
HOMEPAGE="http://launchpad.net/usb-creator"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk kde"

DEPEND="sys-devel/gettext
	dev-python/python-distutils-extra"
RDEPEND="${DEPEND}
	gtk? ( dev-python/pygtk )
	kde? ( dev-python/PyQt4 )"

S="${WORKDIR}/${PN}.trunk"

src_install() {
	distutils_src_install
	! use kde && find "${D}" -name '*kde*' -exec rm -rf '{}' \;
	! use gtk && find "${D}" -name '*gtk*' -exec rm -rf '{}' \;
	use gtk && {
		insinto /usr/share/icons/hicolor/16x16/apps
		newins "${S}"/debian/Debian/usb-creator-gtk-16x16.xpm usb-creator-gtk.xpm
		insinto /usr/share/icons/hicolor/32x32/apps
		newins "${S}"/debian/Debian/usb-creator-gtk-32x32.xpm usb-creator-gtk.xpm
	}
	use kde && {
		insinto /usr/share/icons/hicolor/16x16/apps
		newins "${S}"/debian/Debian/usb-creator-kde-16x16.xpm usb-creator-kde.xpm
		insinto /usr/share/icons/hicolor/32x32/apps
		newins "${S}"/debian/Debian/usb-creator-kde-32x32.xpm usb-creator-kde.xpm
	}
}
