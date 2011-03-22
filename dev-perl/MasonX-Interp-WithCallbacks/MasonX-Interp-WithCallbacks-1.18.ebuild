# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="DWHEELER"
inherit perl-module

DESCRIPTION="Mason callback support via Params::CallbackRequest."

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test" # test require apache binary

DEPEND="virtual/perl-Module-Build"
RDEPEND="dev-perl/HTML-Mason
	virtual/perl-Test-Simple
	dev-perl/Class-Container
	dev-perl/Params-CallbackRequest"
