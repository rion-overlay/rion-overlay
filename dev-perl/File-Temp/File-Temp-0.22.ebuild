# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MODULE_AUTHOR="TJENNESS"
inherit perl-module

DESCRIPTION="Return name and handle of a temporary file safely"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-File-Spec
	virtual/perl-File-Path"
RDEPEND="${DEPEND}"

SRC_TEST="do parallel"
