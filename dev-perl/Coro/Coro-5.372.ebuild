# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="MLEHMANN"
inherit perl-module

DESCRIPTION="The only real threads in perl."

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Event
	dev-perl/AnyEvent
	dev-perl/common-sense
	virtual/perl-Scalar-List-Utils
	dev-perl/EV
	dev-perl/AnyEvent
	virtual/perl-Storable
	virtual/perl-Time-HiRes
	dev-perl/Guard
	dev-perl/IO-AIO"

DEPEND="${RDEPEND}"

SRC_TEST="do"
