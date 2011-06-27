# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="RCAPUTO"
inherit perl-module

DESCRIPTION="Non-blocking, concurrent DNS requests"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/POE-1.280
		>=dev-perl/Net-DNS-0.59"
RDEPEND="${DEPEND}"
SRC_TEST="do"
