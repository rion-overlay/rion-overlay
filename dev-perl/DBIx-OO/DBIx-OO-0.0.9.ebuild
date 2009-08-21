# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTOR=MISHOO
inherit perl-module

DESCRIPTION="Database to Perl objects abstraction"
SRC_URI="mirror://cpan/authors/id/M/MI/${MODULE_AUTOR}/${P}.tar.gz"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-perl/SQL-Abstract
	dev-perl/Test-Pod-Coverage
	dev-perl/Class-Data-Inheritable
	dev-perl/DBI
	virtual/perl-Module-Load"

RDEPEND=""
#  virtual/perl-ExtUtils-MakeMaker
# I`s install depend
