# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="TCP SYN signatures to detect OS type in iptables osf module"
HOMEPAGE="http://www.openbsd.org/cgi-bin/cvsweb/src/etc/pf.os"
SRC_URI="http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/etc/pf.os?rev="${PV}";content-type=text%2Fplain
-> "${P}""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}"
}

src_install() {
	insinto etc
	newins ${P} pf.os
}
