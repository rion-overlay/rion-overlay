# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MODULE_AUTHOR="UNERA"

inherit perl-module

DESCRIPTION="module for accessing to rtorrent's SCGI functions"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/RPC-XML
	dev-perl/MIME-Types
	virtual/perl-Encode"
RDEPEND="${DEPEND}"
