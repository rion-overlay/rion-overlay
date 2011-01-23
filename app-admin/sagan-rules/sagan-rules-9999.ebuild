# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit subversion

DESCRIPTION="Rules for Sagan log analizer"
HOMEPAGE="http://sagan.softwink.com/"
ESVN_REPO_URI="http://svn.softwink.com/svn/repos/sagan-rules/trunk"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
PDEPEND="app-admin/sagan"

S="${WORKDIR}"/rules

src_install() {
	insinto /etc/sagan-rules
	doins -r ./* || die
}
