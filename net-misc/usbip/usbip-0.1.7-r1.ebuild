# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils toolchain-funcs linux-info

DESCRIPTION="A general USB device sharing system over IP networks"
HOMEPAGE="http://usbip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="static-libs"

RDEPEND=">=sys-fs/sysfsutils-2
		virtual/libusb:0
		dev-libs/glib
		sys-apps/tcp-wrappers"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1
S="${WORKDIR}/${P}/src"
DOCS=(README)
pkg_setup() {
	CONFIG_CHECK="USB_IP_COMMON"
	CONFIG_CHECK="USB_IP_VHCI_HCD"
	CONFIG_CHECK="USB_IP_HOST"
}

src_prepare() {
	eautoreconf
}

src_configure() {

	local myeconfargs=( --with-usbids-dir=/usr/share/misc/ )
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	newinitd "${FILESDIR}/usbip.init" usbip
}
