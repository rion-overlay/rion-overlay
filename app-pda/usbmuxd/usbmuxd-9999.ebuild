# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools
if [[ "${PV}" == 9999* ]]; then
	inherit git
	EGIT_REPO_URI="http://git.marcansoft.com/repos/usbmuxd.git"
else
	inherit versionator
	MY_P="${PN}-$(replace_version_separator 3 '-')"
	SRC_URI="http://marcansoft.com/uploads/usbmuxd/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Support library to communicate with iPhone/iPod touch"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"

LICENSE="GPL-2"
KEYWORDS="~x86"
SLOT="0"
IUSE=""

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_unpack() {
	if [[ "${PV}" == 9999* ]]; then
		git_src_unpack || die "unpack failed"
	else
		unpack "${A}"
	fi
}

src_prepare() {
	cd "${S}"
	eautoreconf || die "reconf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README
}

