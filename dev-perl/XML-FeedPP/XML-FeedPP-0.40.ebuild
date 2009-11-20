# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="KAWASAKI"
inherit perl-module

DESCRIPTION="Parse/write/merge/edit RSS/RDF/Atom syndication feeds"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-perl/XML-TreePP-0.38"
RDEPEND="${DEPEND}"
SRC_TEST="do"
