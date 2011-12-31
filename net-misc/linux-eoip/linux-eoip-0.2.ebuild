# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Linux support for proprietary MIkrotik EoIP protocol"
HOMEPAGE="http://code.google.com/p/linux-eoip/"
SRC_URI="http://linux-eoip.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	exeinto /usr/sbin
	doexe meoip

	# doins in openrc sh script to net ;) "${FILESDIR}/"meoip.init meoip

	insinto /etc
	doins  "${FILESDIR}/"meoip.cfg
}
