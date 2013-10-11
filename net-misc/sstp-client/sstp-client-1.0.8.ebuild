# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Client for the proprietary Microsoft Secure Socket Tunneling
Protocol, SSTP."
HOMEPAGE="http://sourceforge.net/projects/sstp-client/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/openssl
	dev-libs/libevent
	>=net-dialup/ppp-2.4.5"
RDEPEND="${DEPEND}"

