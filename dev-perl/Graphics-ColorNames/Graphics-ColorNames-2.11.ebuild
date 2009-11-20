# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="RRWO"
inherit perl-module

DESCRIPTION="defines RGB values for common color names"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/Test-Exception
	virtual/perl-File-Spec
	>=virtual/perl-Module-Load-0.10
	dev-perl/Module-Loaded"
RDEPEND="${DEPEND}"
RC_TEST="do"
