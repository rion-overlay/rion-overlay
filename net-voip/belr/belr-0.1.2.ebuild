# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="VCard parser"
HOMEPAGE="https://savannah.nongnu.org/projects/linphone/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="net-libs/bctoolbox"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
