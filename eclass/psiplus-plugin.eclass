# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="${PN#psi-}plugin"
SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="subversion"
	ESVN_REPO_URI="http://psi-dev.googlecode.com/svn/trunk/plugins/generic/${MY_PN}"
fi

inherit qt4-r2 ${SCM}

HOMEPAGE="http://psi-dev.googlecode.com"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	S="${WORKDIR}/${MY_PN}"
else
	SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">net-im/psi-0.14[extras,plugins]"
RDEPEND="${DEPEND}"

EXPORT_FUNCTIONS src_prepare src_configure

psiplus-plugin_src_prepare() {
	qt4-r2_src_prepare

	sed -e 's#\.\./\.\./psiplugin.pri#/usr/share/psi/plugins/psiplugin.pri#' \
		-i "${MY_PN}".pro || die
}

psiplus-plugin_src_configure() {
	eqmake4 "${MY_PN}".pro
}
