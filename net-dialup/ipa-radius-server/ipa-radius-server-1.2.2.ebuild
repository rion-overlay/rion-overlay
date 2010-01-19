# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Set of libraries common to IPA clients and servers"
HOMEPAGE="http://www.freeipa.org"
SRC_URI="http://freeipa.org/downloads/src/freeipa-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/ipa-python"
RDEPEND=""

S="${WORKDIR}"/"freeipa-${PV}/${PN}"

src_compile() { : ; }
src_install() {
	emake DESTDIR="${D}" install  || die "emake failed"
}
