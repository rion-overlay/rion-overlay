# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=MSERGEANT

inherit perl-module

DESCRIPTION="Perl extension for access to cdb databases"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_TEST="do"
IUSE=""
DEPEND="sys-libs/gdbm"
RDEPEND="${DEPEND}"
