# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python autotools git

EGIT_REPO_URI="git://github.com/MattColyer/libiphone.git"
DESCRIPTION="Library for access to a iphone and ipod touch without a jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug python"

RDEPEND="app-pda/libplist
		app-pda/usbmuxd
		dev-libs/glib:2
		dev-libs/libgcrypt
		net-libs/gnutls
		sys-fs/fuse
		virtual/libusb:0"

DEPEND="dev-util/pkgconfig
		python? ( dev-lang/swig[python] )
		${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure(){
	econf \
		--enable-dev-tools \
		$(use_enable debug debug-code) \
		$(use_with python swig) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
