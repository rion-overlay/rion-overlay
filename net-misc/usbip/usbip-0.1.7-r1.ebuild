# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools toolchain-funcs

DESCRIPTION="A general USB device sharing system over IP networks"
HOMEPAGE="http://usbip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=sys-fs/sysfsutils-2
		virtual/libusb:0
		dev-libs/glib
		sys-apps/tcp-wrappers"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${P}/src"

pkg_config() {
	if $(gcc-version) < 4;then
		eerror "You gcc verision is old"
		eerror "This package only gcc 4 style"
		eerror "Please install >gcc-4* "
	fi
}

src_prepare() {
	eautoreconf
}

src_configure() {

econf	--with-usbids-dir=/usr/share/misc/  || die "econf failed"
}

src_compile() {

	emake all-recursive || die
}

src_install() {

	emake DESTDIR="${D}" install || die " install failed"
	dodoc README*

	newinitd "${FILESDIR}/usbip.init" usbip
}
