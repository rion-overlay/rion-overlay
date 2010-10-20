# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4-r2 subversion

MY_PN="${PN/*-}plugin"
HOMEPAGE="http://psi-dev.googlecode.com"
ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk/plugins/generic/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"

DEPEND=">net-im/psi-0.14[extras,plugins]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

EXPORT_FUNCTIONS src_prepare

psiplus-plugin_src_prepare() {
	qt4-r2_src_prepare
	sed 's#\.\./\.\./psiplugin.pri#/usr/share/psi/plugins/psiplugin.pri#' \
		-i "${MY_PN}".pro
	eqmake4 "${MY_PN}".pro QMAKE_STRIP=echo
}
