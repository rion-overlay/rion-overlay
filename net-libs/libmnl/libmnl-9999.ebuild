# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2 autotools autotools-utils

DESCRIPTION="Minimalistic nelink library"
HOMEPAGE="http://netfilter.org/projects/libmnl"
EGIT_REPO_URI="git://git.netfilter.org/libmnl.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1
DOCS=(README)
src_unpack() {
	git-2_src_unpack
}

src_prepare(){
	eautoreconf
}
