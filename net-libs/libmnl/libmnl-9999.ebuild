# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git autotools

DESCRIPTION="Minimalistic nelink library"
HOMEPAGE="http://netfilter.org/projects/libmnl"
EGIT_REPO_URI="git://git.netfilter.org/libmnl.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	git_src_prepare
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
}
