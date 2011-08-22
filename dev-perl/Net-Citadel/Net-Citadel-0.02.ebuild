# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MODULE_AUTHOR="DRRHO"

inherit perl-module

DESCRIPTION="Citadel.org protocol coverage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Config-YAML"
RDEPEND="${DEPEND}"
