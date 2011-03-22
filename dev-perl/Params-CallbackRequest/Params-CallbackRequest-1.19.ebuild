# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="DWHEELER"
inherit perl-module

DESCRIPTION="Functional and object-oriented callback architecture"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/perl-Module-Build
	${RDEPEND}"
RDEPEND="virtual/perl-File-Spec"

SRC_TEST="do"
