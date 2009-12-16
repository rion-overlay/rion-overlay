# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="c2ctl is overclocking and undervolting the CPU and to enable Intel SpeedStep."
HOMEPAGE="http://www.ztex.de/misc/c2ctl.e.html"
SRC_URI="http://www.ztex.de/misc/c2ctl.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
QA_PRESTRIPPED="/usr/sbin/c2ctl"
S="${WORKDIR}"/c2ctl

src_compile() { : ; }

src_install() {
	dosbin "${S}"/c2ctl
	dodoc Readme
}
