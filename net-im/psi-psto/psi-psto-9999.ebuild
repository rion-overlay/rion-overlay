# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit psiplus-plugin #mercurial

DESCRIPTION="Psi plugin for psto.net service"
KEYWORDS=""
IUSE=""


src_prepare() {
	S="${WORKDIR}/plugins/dev/${MY_PN}"
	cd "${S}"
	qt4-r2_src_prepare
	sed -e 's#\.\./\.\./psiplugin.pri#/usr/share/psi-plus/plugins/psiplugin.pri#' \
	-i "${MY_PN}".pro || die
}
 
src_configure() {
	cd "${S}"
	eqmake4 "${MY_PN}".pro
}