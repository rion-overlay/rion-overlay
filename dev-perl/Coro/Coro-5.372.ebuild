# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="MLEHMANN"
inherit perl-module

DESCRIPTION=""

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Event
	dev-perl/AnyEvent
	dev-perl/common-sense
	virtual/perl-Scalar-List-Utils
	dev-perl/EV"
DEPEND="${RDEPEND}"

SRC_TEST="do"
