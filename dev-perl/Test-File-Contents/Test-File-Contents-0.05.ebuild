# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="SKUD"
inherit perl-module

DESCRIPTION="Test routines for examining the contents of files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-Module-Build"
RDEPEND="dev-lang/perl"

SRC_TEST="do"
