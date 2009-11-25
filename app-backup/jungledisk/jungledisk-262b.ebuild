# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="2"

DESCRIPTION="Jungle Disk is Amazon c3 cloud disk interface"
HOMEPAGE="https://www.jungledisk.com/"
SRC_URI="amd64? ( http://downloads."${PN}".com/"${PN}"/"${PN}"64-"${PV}".tar.gz )
			x86? ( http://downloads."${PN}".com/"${PN}"/"${PN}""${PV}".tar.gz )"

LICENSE="JUNGLE_DISK"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"
RESTRICT="strip"
DEPEND="!minimal? ( x11-libs/gtk+:2 )"
RDEPEND=""

S="${WORKDIR}"/"${PN}"
QA_EXEC_STACK="usr/bin/jungledisk usr/bin/junglediskmonitor"
src_install() {
	insinto /usr/bin
	doins jungledisk
	if use !minimal;then
		insinto /usr/bin
		doins junglediskmonitor
	fi
	dodoc INSTALL
}
pkg_postinst() {
	elog "Plz. read INSTALL file in documentation direktory"
}
