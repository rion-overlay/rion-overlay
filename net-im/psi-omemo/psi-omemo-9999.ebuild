# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit psi-plugin

DESCRIPTION="OMEMO encryption support for Psi instant messenger"

KEYWORDS=""
IUSE=""

RDEPEND="net-libs/libomemo-c"
DEPEND="$RDEPEND"
