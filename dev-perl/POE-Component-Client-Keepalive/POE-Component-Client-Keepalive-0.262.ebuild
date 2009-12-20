# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="RCAPUTO"
inherit perl-module

DESCRIPTION="manage connections, with keep-alive"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/POE-1.280
		>=dev-perl/POE-Component-Client-DNS-1.051
		dev-perl/Net-IP"
RDEPEND="${DEPEND}"
SRC_TEST="do"
