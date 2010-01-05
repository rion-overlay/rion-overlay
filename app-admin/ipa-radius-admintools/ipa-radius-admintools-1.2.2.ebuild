# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="Set of libraries common to IPA clients and servers"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/"freeipa-${PV}/${PN}"

src_compile() { : ; }
src_install() {
	dosbin "${S}"/ipa-* || die
}

