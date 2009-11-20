# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="CJM"
inherit perl-module

DESCRIPTION="Case preserving but case insensitive hash table"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="perl-core/File-Spec"
RDEPEND="${DEPEND}"
SRC_TEST="do parallel"
