# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit psiplus-plugin

DESCRIPTION="Psi skins plugin."

KEYWORDS=""
IUSE="+themes"

RDEPEND="themes? ( !net-im/psi-skins-themes )"

src_unpack() {
	git-2_src_unpack

	if use themes; then
		EGIT_DIR="${EGIT_STORE_DIR}/psi-plus/resources" \
		EGIT_SOURCEDIR="${WORKDIR}/resources" \
		EGIT_REPO_URI="git://github.com/psi-plus/resources.git" git-2_src_unpack
	fi
}

src_install() {
	qt4-r2_src_install

	if use themes; then
		cd "${WORKDIR}/resources" || die
		insinto /usr/share/psi-plus/skins
		doins -r skins/*
	fi
}
