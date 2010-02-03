# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: qca-plugin.eclass
# @MAINTAINER:
# Rion <rion4ik@gmail.com>
# @BLURB: Eclass for QCA plugins
# @DESCRIPTION:
# This eclass will be used to build all svn qca plugins

inherit eutils qt4 subversion 

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
	cd "${S}/plugins/${PN}"
	qt4_src_prepare
	qconf
}

# @FUNCTION: qca-plugin_src_configure
# @MAINTAINER:
# rion <rion4ik@gmail.com>
# @DESCRIPTION:
# Default src_configure function for packages that depends on qca-plugin
qca-plugin_src_configure() {
	cd "${S}/plugins/${PN}"
	# cannot use econf because of non-standard configure script
	./configure \
		--qtdir=/usr \
		$(use debug && echo "--debug" || echo "--release") \
		--no-separate-debug-info \
		|| die "configure failed"
}

# @FUNCTION: qca-plugin_src_compile
# @MAINTAINER:
# rion <rion4ik@gmail.com>
# @DESCRIPTION:
# Default src_compile function for packages that depends on qca-plugin
qca-plugin_src_compile() {
	cd "${S}/plugins/${PN}"
	eqmake4 ${PN}.pro
	emake || die "emake failed"
}                                  


# @FUNCTION: qca-plugin_src_install
# @MAINTAINER:
# rion <rion4ik@gmail.com>
# @DESCRIPTION:
# Default src_install function for packages that depends on qca-plugin
qca-plugin_src_install() {
	cd "${S}/plugins/${PN}"
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}

EXPORT_FUNCTIONS src_prepare src_configure src_compile src_install
