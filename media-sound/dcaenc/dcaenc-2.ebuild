# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools

DESCRIPTION="Encoder for the DTS Coherent Acoustics audio format"
HOMEPAGE="http://aepatrakov.narod.ru/dcaenc/"
SRC_URI="http://aepatrakov.narod.ru/dcaenc/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

DEPEND="alsa? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable alsa)
}
