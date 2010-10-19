# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="DWHEELER"
inherit perl-module

DESCRIPTION="XHTML format for Text::Diff::Unified"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-Module-Build"
RDEPEND="dev-perl/Text-Diff"

SRC_TEST="do"
