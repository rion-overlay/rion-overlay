# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit subversion
HOMEPAGE="http://psi-dev.googlecode.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""


ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk/skins/"

src_install() {
	find "${S}" -name *win32* -delete
	find "${S}" -name *mac* -delete
	insinto /usr/share/psi/skins
	doins -r "${S}"/*
}
