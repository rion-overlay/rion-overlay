# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit git autotools

IUSE=""

DESCRIPTION="Support library to communicate with iPhone/iPod touch"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
SRC_URI=""
EGIT_REPO_URI="http://pims.selfip.net/git/usbmuxd/"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND=">=sys-devel/autoconf-2.60b
	>=sys-devel/automake-1.10"
RDEPEND="virtual/libusb:0"

src_unpack() {
	git_src_unpack || die "unpack failed"
}

src_prepare() {
	eautoreconf || die "reconf failed"
}

src_configure() {
	econf || die "failed econf"
}

src_compile() {
	emake all || die "failed emake"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS COPYING README
}

