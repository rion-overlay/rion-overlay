# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qca-plugin.eclass
# @MAINTAINER:
# Rion <rion4ik@gmail.com>
# @BLURB: Eclass for QCA plugins
# @DESCRIPTION:
# This eclass will be used to build all svn qca plugins

inherit eutils qt4-r2 subversion 

IUSE="debug"
SLOT="2"
ESVN_REPO_URI="svn://websvn.kde.org:443/home/kde/trunk/kdesupport/qca/"
ESVN_PROJECT="qca"
DEPEND=">=app-crypt/qca-${PV}[debug?]"
RDEPEND="${DEPEND}"

# @FUNCTION: qca-plugin_src_prepare
# @MAINTAINER:
# rion <rion4ik@gmail.com>
# @DESCRIPTION:
# Default src_prepare function for packages that depends on qca-plugin
qca-plugin_src_prepare() {
	S="${S}/plugins/${PN}"
	cd "${S}"
	qt4_src_prepare
}

# @FUNCTION: qca-plugin_src_configure
# @MAINTAINER:
# rion <rion4ik@gmail.com>
# @DESCRIPTION:
# Default src_configure function for packages that depends on qca-plugin
qca-plugin_src_configure() {
	qconf
	# cannot use econf because of non-standard configure script
	./configure \
		--qtdir=/usr \
		$(use debug && echo "--debug" || echo "--release") \
		--no-separate-debug-info \
		|| die "configure failed"
	eqmake4 ${PN}.pro
}

EXPORT_FUNCTIONS src_prepare src_configure
