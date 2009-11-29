# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils

DESCRIPTION="A reverse-engineered Linux driver for mobile WiMAX devices based on Samsung CMC-730 chip."
HOMEPAGE="http://code.google.com/p/madwimax/"
SRC_URI="http://madwimax.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}
		app-text/txt2man"

src_configure() {
	epatch "${FILESDIR}/${P}"-led.patch
	econf --without-man-pages
}

src_compile() {
	emake || die "emake failed"
	cd "${S}"/man
	txt2man madwimax.8.txt > madwimax.8
}

src_install() {
	dodoc README TODO THANKS AUTHORS ChangeLog
	dosbin src/madwimax
	doman man/madwimax.8
	insinto /etc/udev/rules.d/
	newins scripts/udev/z60_madwimax.rules 60-madwimax.rules
	exeinto /etc/madwimax
	doexe scripts/events/event.sh
}
