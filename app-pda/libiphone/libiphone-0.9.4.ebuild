# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit autotools
if [[ "${PV}" == 9999* ]]; then
	inherit git
	EGIT_REPO_URI="git://github.com/MattColyer/libiphone.git"
else
	SRC_URI="http://cloud.github.com/downloads/MattColyer/${PN}/${P}.tar.bz2"
fi

DESCRIPTION="Library for access to a iphone and ipod touch without a jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"

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
	if [[ "${PV}" == 9999* ]]; then
		git_src_unpack
	else
		unpack "${A}"
	fi
	cd "${S}"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
