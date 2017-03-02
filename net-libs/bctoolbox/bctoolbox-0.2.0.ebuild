# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Utilities library used by Belledonne Communications softwares"
HOMEPAGE="https://savannah.nongnu.org/projects/linphone/"
#SRC_URI="http://download.savannah.nongnu.org/releases/exosip/${P}.tar.gz"
SRC_URI="http://ftp.acc.umu.se/mirror/gnu.org/savannah/linphone/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="+mbedtls polarssl test"
REQUIRED_EUSE="^^ ( mbedtls polarssl )"

DEPEND="dev-util/cunit
	polarssl? ( net-libs/polarssl )
	mbedtls? ( net-libs/mbedtls )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconfargs=(
		$(use_with polarssl polarssl=/usr/$(get_libdir))
		$(use_with mbedtls mbedtls=/usr/$(get_libdir))
	)
	econf "${myconfargs[@]}"
}
