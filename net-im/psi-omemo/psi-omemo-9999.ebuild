# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit psi-plugin

DESCRIPTION="Psi plugin for OMEMO"

KEYWORDS=""
IUSE=""

RDEPEND="net-libs/libsignal-protocol-c
	app-crypt/qca"
DEPEND="$RDEPEND"
