# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 subversion

DESCRIPTION="XML-RPC library written with Qt in mind"
HOMEPAGE="http://code.google.com/p/qxmlrpc/"
ESVN_REPO_URI="http://backharddi.ideseneca.es/svn/tags/unstable/backharddi-net/monitor/qxmlrpc/"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/qt-core"
RDEPEND="${DEPEND}"

src_compile()
{
	eqmake4
	emake || die "make failed"
}

src_install() {
	mkdir -p "${D}"/usr/$(get_libdir)
	cp -P lib* "${D}"/usr/$(get_libdir)/

	insinto /usr/include/qxmlrpc
	doins xmlrpc/*.h
}
