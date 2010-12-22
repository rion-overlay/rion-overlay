# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit psiplus-plugin

DESCRIPTION="Psi skins plugin."

KEYWORDS=""
IUSE="+themes"

RDEPEND="themes? ( !net-im/psi-skins-themes )"

src_unpack() {
	subversion_src_unpack

	if use themes; then
		ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk/skins/" \
		ESVN_PROJECT="${MY_PN}-themes" \
		S="${WORKDIR}/skins" \
		subversion_fetch
	fi
}

src_install() {
	qt4-r2_src_install

	if use themes; then
		cd "${WORKDIR}" || die
		insinto /usr/share/psi/skins
		doins -r skins/*
	fi
}
