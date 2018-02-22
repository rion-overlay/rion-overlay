# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PLUGIN_DIR="dev"
inherit psi-plugin

DESCRIPTION="Psi plugin for OMEMO"

KEYWORDS=""
IUSE=""

RDEPEND="=net-libs/libsignal-protocol-c-2.3.2_alpha1"
DEPEND="$RDEPEND"
