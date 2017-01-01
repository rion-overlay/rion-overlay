# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base rpm

DESCRIPTION="Wsman Shell Command Line "whistle""
HOMEPAGE="http://linux.dell.com/files/wsl/"
SRC_URI="mirror://debian/pool/main/w/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libxml2
	>=net-misc/wget-1.13
	net-misc/curl
	app-crypt/gnupg
	dev-libs/libxslt
	"

RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}"/*.patch )

src_install() {
	insinto /usr/share/${PN}
	doins wsl-functions
	doins wsl-ws2textc.xsl

	dobin viwsl
	dobin wsl
	dobin wslcred
	dobin wslecn
	dobin wslenum
	dobin wslget
	dobin wslid
	dobin wslinvoke
	dobin wslput
	dobin wxmlgetvalue

	dodoc README-wsl

	doman wsl.1
}
