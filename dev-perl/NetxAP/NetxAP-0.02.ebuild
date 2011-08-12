# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MODULE_AUTHOR="KJOHNSON"
inherit perl-module

DESCRIPTION="A base class for protocols such as IMAP, ACAP, IMSP, and ICAP."

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-MIME-Base64
	dev-perl/MD5
	virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}"

SRC_TEST=""
