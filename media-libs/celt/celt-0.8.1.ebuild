# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib

DESCRIPTION="CELT is a very low delay audio codec designed for high-quality communications."
HOMEPAGE="http://www.celt-codec.org/"
SRC_URI="http://downloads.us.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ogg"

DEPEND="ogg? ( media-libs/libogg )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with ogg ogg /usr)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog README TODO || die "dodoc failed."

	find "${D}" -name '*.la' -delete
}
