# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit subversion

DESCRIPTION="wireless performance test tool"
HOMEPAGE="http://code.google.com/p/zapwireless
			http://www.ruckuswireless.com/"

ESVN_REPO_URI="http://zapwireless.googlecode.com/svn/trunk/"
ESVN_REVISION="2"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
# TODO - fix Makefile

src_prepare() {
	subversion_bootstrap
	sed -i -e 's/CFLAGS=/CFLAGS+=/' Makefile || die
}
src_install() {
	dobin "${S}/bin/linux/"zap*
}
