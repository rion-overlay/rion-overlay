# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI="2"

DESCRIPTION="HTB class tree viewer of alexpro (Alexey Prokopchuk)"
HOMEPAGE="http://gentoo.homelan.lg.ua/distrib"
SRC_URI="http://gentoo.homelan.lg.ua/distrib/htbstat-0.9.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
RDEPEND="sys-apps/iproute2"

src_install() {
	dobin "${S}"/htbstat
}
