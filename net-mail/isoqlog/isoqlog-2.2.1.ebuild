# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base eutils

DESCRIPTION="Isoqlog is an MTA log analysis program written in C."
HOMEPAGE="http://www.enderunix.org/isoqlog"
SRC_URI="http://www.enderunix.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${S}" install || die

	dobin "${S}/usr/bin"/isoqlog || die "dobin failed"
	insinto /etc/"${PN}"
	doins 	"${S}/usr/"etc/*dist

	insinto  /usr
	doins -r "${S}/usr"/share

	ecompressdir  usr/share/doc/isoqlog/
}
