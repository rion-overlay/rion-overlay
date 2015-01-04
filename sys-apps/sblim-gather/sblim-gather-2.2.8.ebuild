# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="SBLIM Performance Data Gatherer"
HOMEPAGE="http://www.sblim.org"
SRC_URI="mirror://sourceforge/project/sblim/${PN}/${PV}/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+base libvirt +provider"

CDEPEND="
	dev-libs/sblim-cmpi-devel
	sys-apps/sblim-cmpi-base
	libvirt? ( app-emulation/libvirt )
	"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	app-text/xmlto"

src_configure() {

	local myeconfargs=(
		$(use_enable libvirt virt)
		$(use_enable base)
		$(use_enable provider)
		)
	autotools-utils_src_configure
}
