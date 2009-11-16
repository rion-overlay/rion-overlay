# Copyright 2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/qt4.eclass,v 1.38 2008/03/26 01:23:13 rion Exp $

# @ECLASS: qca-plugin.eclass
# @MAINTAINER:
# Rion <rion@plotinka.ru>
# @BLURB: Eclass for QCA plugins
# @DESCRIPTION:
# This eclass will be used to build all svn qca plugins

inherit eutils qt4 subversion 

IUSE="debug"
SLOT="2"
ESVN_REPO_URI="svn://websvn.kde.org:443/home/kde/trunk/kdesupport/qca/"
ESVN_PROJECT="qca"
DEPEND=">=app-crypt/qca-${PV}"
RDEPEND="${RDEPEND} >=app-crypt/qca-${PV}"

# @FUNCTION: qca-plugin_pkg_setup
# @MAINTAINER:
# rion <rion@plotinka.ru>
# @DESCRIPTION:
# Default pkg_setup function for packages that depends on qt-plugin
qca-plugin_pkg_setup() {
	if use debug && ! built_with_use ">=app-crypt/qca-9999" debug; then
		echo
		eerror "You are trying to compile ${PN} with USE=\"debug\""
		eerror "while qca is built without this flag. It will not work."
		echo
		eerror "Possible solutions to this problem are:"
		eerror "a) install ${PN} without debug USE flag"
		eerror "b) re-emerge qca with debug USE flag"
		echo
		die "can't emerge ${PN} with debug USE flag"
	fi
}


# @FUNCTION: qca-plugin_src_unpack
# @MAINTAINER:
# rion <rion@plotinka.ru>
# @DESCRIPTION:
# Default pkg_setup function for packages that depends on qt-plugin
qca-plugin_src_unpack() {
	subversion_src_unpack
	cd "${S}/plugins/${PN}"
	qconf
}


# @FUNCTION: qca-plugin_src_compile
# @MAINTAINER:
# rion <rion@plotinka.ru>
# @DESCRIPTION:
# Default src_compile function for packages that depends on qt-plugin
qca-plugin_src_compile() {
	cd "${S}/plugins/${PN}"
	# cannot use econf because of non-standard configure script
	./configure \
		--qtdir=/usr \
		$(use debug && echo "--debug" || echo "--release") \
		--no-separate-debug-info \
		|| die "configure failed"

	eqmake4 ${PN}.pro
	emake || die "emake failed"
}                                  


# @FUNCTION: qca-plugin_src_install
# @MAINTAINER:
# rion <rion@plotinka.ru>
# @DESCRIPTION:
# Default src_install function for packages that depends on qt-plugin
qca-plugin_src_install() {
	cd "${S}/plugins/${PN}"
	emake INSTALL_ROOT="${D}" install || die "make install failed"
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install
