# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MODULE_AUTOR=RHANDO
inherit perl-module


DESCRIPTION="TT2/3, HT, HTE, Tmpl, and Velocity Engine"
SRC_URI="mirror://cpan/authors/id/R/RH/RHANDOM/"${P}".tar.gz"

IUSE=""

SLOT="0"
KEYWORDS="~x86 ~amd64"

RDEPEND="virtual/perl-Digest-MD5"
SRC_TEST="do"
