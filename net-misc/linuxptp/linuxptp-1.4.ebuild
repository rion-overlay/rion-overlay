# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Precision Time Protocol (PTP)  for Linux (  IEEE standard 1588 )"
HOMEPAGE="http://linuxptp.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/v1.4/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	emake all
}

src_install() {
	dosbin hwstamp_ctl ptp4l pmc phc2sys

	insinto /etc/${PN}
	doins default.cfg  gPTP.cfg
	doman hwstamp_ctl.8  phc2sys.8  pmc.8  ptp4l.8
}
