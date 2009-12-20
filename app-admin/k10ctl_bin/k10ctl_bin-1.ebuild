# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="k10ctl is overclocking and undervolting the CPU and to configure Cool'n'Quiet settings"
HOMEPAGE="http://www.ztex.de/misc/k10ctl.e.html"
SRC_URI="http://www.ztex.de/misc/k10ctl.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
QA_PRESTRIPPED="/usr/sbin/k10ctl"
S="${WORKDIR}"/k10ctl

src_compile() { : ; }

src_install() {
	dosbin "${S}"/k10ctl
	dodoc Readme
}
