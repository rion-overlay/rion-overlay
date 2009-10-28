# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit versionator

DESCRIPTION="Support library to communicate with iPhone/iPod touch"
MY_P="${PN}-$(replace_version_separator 3 '-')"
SRC_URI="http://marcansoft.com/uploads/usbmuxd/${MY_P}.tar.bz2"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	ewarn "$MY_P"
	unpack "${A}"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README
}

