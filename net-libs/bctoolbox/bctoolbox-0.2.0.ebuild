# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Utilities library used by Belledonne Communications softwares"
HOMEPAGE="https://savannah.nongnu.org/projects/linphone/"
SRC_URI="http://ftp.acc.umu.se/mirror/gnu.org/savannah/linphone/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="dev-util/cunit
	net-libs/mbedtls"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}
