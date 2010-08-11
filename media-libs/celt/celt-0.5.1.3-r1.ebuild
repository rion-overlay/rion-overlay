# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"

inherit autotools

DESCRIPTION="CELT is a very low delay audio codec designed for high-quality communications."
HOMEPAGE="http://www.celt-codec.org/"
SRC_URI="http://downloads.us.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="as-is"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="ogg"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/libtool"
RDEPEND="ogg? ( media-libs/libogg )"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ogg ogg /usr) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog README TODO || die "dodoc failed."

	find "${D}" -name '*.la' -delete
}
