# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

inherit psiplus-plugin

DESCRIPTION="Psi skins plugin."

KEYWORDS=""
IUSE="+themes"

RDEPEND="themes? ( !net-im/psi-skins-themes )"

src_unpack() {
	psiplus-plugin_src_unpack

	if use themes; then
		EGIT_DIR="${EGIT_STORE_DIR}/psi-plus/resources" \
		EGIT_CHECKOUT_DIR="${WORKDIR}/resources" \
		EGIT_REPO_URI="git://github.com/psi-plus/resources.git" git-r3_src_unpack
	fi
}

src_install() {
	psiplus-plugin_src_install

	if use themes; then
		cd "${WORKDIR}/resources" || die
		insinto /usr/share/psi-plus/skins
		doins -r skins/*
	fi
}
