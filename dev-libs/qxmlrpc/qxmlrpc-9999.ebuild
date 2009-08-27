# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit qt4 subversion

DESCRIPTION="XML-RPC library written with Qt in mind"
HOMEPAGE="http://code.google.com/p/qxmlrpc/"
ESVN_REPO_URI="http://backharddi.ideseneca.es/svn/tags/unstable/backharddi-net/monitor/qxmlrpc/"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/qt-core"
RDEPEND="${DEPEND}"

src_compile()
{
	eqmake4
	emake || die "make failed"
}

src_install() {
	insinto /usr/$(get_libdir)
	doins lib*

	insinto /usr/include/qxmlrpc
	doins xmlrpc/*.h
}
