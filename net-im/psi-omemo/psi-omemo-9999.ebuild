# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PLUGIN_DIR="dev"
inherit psi-plugin

DESCRIPTION="Psi plugin for OMEMO"

KEYWORDS=""
IUSE=""

RDEPEND=">=app-crypt/libsignal-protocol-c-2.3.1_p20180209
	>=app-crypt/qca-2.1.3_p20180105"
DEPEND="$RDEPEND"
