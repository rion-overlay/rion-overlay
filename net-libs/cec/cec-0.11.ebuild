# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPU="2"

inherit eutils

DESCRIPTION="Coraid Ethernet Console"
HOMEPAGE="http://sourceforge.net/projects/aoetools/"
SRC_URI="mirror://sourceforge/aoetools/"${PN}"/11/"${PN}"-11.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/"cec-11"

src_install() {

	# Not use target install , it`s stub
	dosbin cec
	doman cec.8
	dodoc cec.txt HACKING  NEWS  README
}
