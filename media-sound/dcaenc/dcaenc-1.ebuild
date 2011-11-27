# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools

DESCRIPTION="Encoder for the DTS Coherent Acoustics audio format"
HOMEPAGE="http://aepatrakov.narod.ru/dcaenc/"
SRC_URI="http://aepatrakov.narod.ru/dcaenc/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa"

DEPEND="alsa? ( media-libs/alsa-lib )"
RDEPEND="alsa? ( media-libs/alsa-lib[alsa_pcm_plugins_extplug] )"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_enable alsa)
}
