# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git
EGIT_REPO_URI="http://git.marcansoft.com/repos/usbmuxd.git"

DESCRIPTION="Support library to communicate with iPhone/iPod touch"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS README
}
