# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="DWHEELER"
inherit perl-module

DESCRIPTION="Track changes between documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-Module-Build
	virtual/perl-File-Spec"
RDEPEND="dev-perl/Algorithm-Diff
	virtual/perl-Term-ANSIColor
	dev-perl/HTML-Parser"

SRC_TEST="do"
