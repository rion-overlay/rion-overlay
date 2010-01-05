# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="RCAPUTO"
inherit perl-module

DESCRIPTION="HTTP user-agent component"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/POE-1.280
		>=dev-perl/libwww-perl-5.831
		dev-perl/URI
		dev-perl/POE-Component-Client-Keepalive
		dev-perl/Test-POE-Server-TCP"
RDEPEND="${DEPEND}"
SRC_TEST="do"
