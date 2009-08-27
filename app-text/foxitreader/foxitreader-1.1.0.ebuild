# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MY_PN="FoxitReader"

DESCRIPTION="Foxit Reader is a small,fast PDF viewer (Linux version)"
HOMEPAGE="http://www.foxitsoftware.com/"
SRC_URI="http://mirrors.foxitsoftware.com/pub/foxit/reader/desktop/linux/1.x/1.1/enu/"${MY_PN}"-"${PV}".tar.bz2"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip"
DEPEND=""
RDEPEND="x11-base/xorg-server
		>=net-print/cups-1.3
		=x11-libs/gtk+-2*[X,cups,jpeg]
		x11-libs/pango
		x11-libs/cairo[X,opengl,xcb,svg]
		media-libs/freetype:2[X]
		net-libs/gnutls
		dev-libs/libgcrypt
		dev-libs/libgpg-error
		amd64? ( app-emulation/emul-linux-x86-xlibs
				app-emulation/emul-linux-x86-gtklibs )"

S="${WORKDIR}"/1.1-release


src_install() {
	dodir /opt/"${MY_PN}"
	cp "${S}"/FoxitReader "${D}"/opt/"${MY_PN}" || die
	cp "${S}"/fpdfcjk.bin  	"${D}"/opt/"${MY_PN}" || die
	cp "${S}"/fum.fhd	"${D}"/opt/"${MY_PN}" || die
	mv "${S}"/po	"${D}"/opt/"${MY_PN}"  || die
	dodoc "${S}"/Readme.txt


}
