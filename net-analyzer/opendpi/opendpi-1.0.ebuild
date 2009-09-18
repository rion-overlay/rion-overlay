# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="OpenDPI the open source deep packet inspection engine"
HOMEPAGE="http://opendpi.org"
SRC_URI="http://opendpi.googlecode.com/files/OpenDPI_1.0.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"OpenDPI"

src_install() {
	emake DESTSIR="${D}" install || die
}
