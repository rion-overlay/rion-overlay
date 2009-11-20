# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit perl-module

DESCRIPTION="Very fast matches large lists of IP addresses against many CIDR subnets"
HOMEPAGE="http://backpan.perl.org/"
SRC_URI="http://backpan.perl.org/authors/id/S/SR/SRI/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
SRC_TEST="do"
