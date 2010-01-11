# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"
WANT_AUTOCONF="2.5"

inherit eutils autotools

DESCRIPTION="A reverse-engineered Linux driver for mobile WiMAX devices based on Samsung CMC-730 chip."
HOMEPAGE="http://code.google.com/p/madwimax/"
SRC_URI="http://madwimax.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="virtual/libusb:1
		doc? ( app-text/txt2man )
		dev-util/pkgconfig"
RDEPEND="virtual/libusb:1
		sys-fs/udev"

src_prepare() {

	epatch "${FILESDIR}/${P}"-led.patch || die "epatch failed"

	eautoreconf
}
src_configure() {
	econf --without-man-pages || die "econf failed"
}

src_compile() {
	emake || die "emake failed"

	if use doc; then
		cd "${S}"/man
		txt2man madwimax.8.txt > madwimax.8
	fi
}

src_install() {
	dodoc README TODO THANKS AUTHORS ChangeLog

	dosbin src/madwimax

	doman man/madwimax.8

	insinto /etc/udev/rules.d/
	doins "${FILESDIR}/"60-madwimax.rules

	newinitd "${FILESDIR}/"madwimax.initd madwimax
	newconfd	"${FILESDIR}/"madwimax.confd madwimax

	exeinto /etc/madwimax
	doexe "${FILESDIR}/"event.sh
}
