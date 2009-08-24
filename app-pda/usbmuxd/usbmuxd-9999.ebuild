# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git autotools

DESCRIPTION="Support library to communicate with iPhone/iPod touch"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
EGIT_REPO_URI="http://pims.selfip.net/git/usbmuxd/"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack || die "unpack failed"
	cd ${S}
	eautoreconf || die "reconf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS COPYING README
}

