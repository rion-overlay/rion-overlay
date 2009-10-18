# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit git autotools

DESCRIPTION="Library for access to a iphone and ipod touch without a jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
EGIT_REPO_URI="git://github.com/MattColyer/libiphone.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="app-pda/libplist
	app-pda/usbmuxd
	dev-libs/glib:2
	dev-libs/libgcrypt
	net-libs/gnutls
	sys-fs/fuse
	virtual/libusb:0"
DEPEND="dev-util/pkgconfig
	${RDEPEND}"

src_unpack() {
	git_src_unpack
	cd "${S}"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
