# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt4 subversion

MY_PN="${PN/*-}plugin"

ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk/plugins/generic/${MY_PN}"

DEPEND="net-im/psi[plugins]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

EXPORT_FUNCTIONS src_compile src_install

psiplus-plugin_src_compile() {
	sed 's#\.\./\.\./psiplugin.pri#/usr/share/psi/plugins/psiplugin.pri#' \
		-i "${MY_PN}".pro
	eqmake4 "${MY_PN}".pro QMAKE_STRIP=echo
	emake || die "Make failed"
}

psiplus-plugin_src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
}
