# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools

DESCRIPTION="Drop not valid DHCP server in you network"
HOMEPAGE="http://www.netpatch.ru/dhcdrop.html"
SRC_URI="http://www.netpatch.ru/projects/"${PN}"/"${PN}"-"${PV}".tar.bz2"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="pic static"

DEPEND=">=net-libs/libpcap-0.9.8"
RDEPEND="${DEPEND}"

S="$WORKDIR"/"${P}"

src_prepare() {
eautoreconf
}
src_configure() {

		econf \
			$(use_with pic) \
			$(use_enable static static-build )

}
src_install() {
	einstall || die
	dodoc ChangeLog README AUTHORS
}

