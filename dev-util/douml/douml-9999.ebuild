# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit qt4-r2 subversion

DESCRIPTION="Powerful UML 2 modelling tool. BoUML fork"
HOMEPAGE="http://douml.sourceforge.net"
ESVN_REPO_URI="https://douml.svn.sourceforge.net/svnroot/douml/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qt3support
	dev-qt/qtsql"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:/usr/lib:/usr/$(get_libdir):" \
		-e "s:/usr/:${EROOT}usr/:" Makefile || die
	subversion_src_prepare
}
