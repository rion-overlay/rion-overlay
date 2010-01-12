# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 subversion

MY_PN="${PN/*-}plugin"

DESCRIPTION="Psi plugin for making attention (XEP-0224)"
HOMEPAGE="http://psi-dev.googlecode.com"
ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk/plugins/generic/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-im/psi[plugins]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	sed 's/\.\.\/\.\.\/psiplugin.pri/\/usr\/share\/psi\/plugins\/psiplugin.pri/' \
		-i "${MY_PN}".pro
	eqmake4 "${MY_PN}".pro
	emake || die "Make failed"
}
