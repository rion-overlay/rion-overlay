# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.10"

inherit autotools

DESCRIPTION="Provide high-quality remote access to QEMU using SPICE protocol"
HOMEPAGE="http://www.spice-space.org http://www.redhat.com/virtualization/rhev"
SRC_URI="http://www.spice-space.org/download/spice_0_4.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

COMMON_DEP="dev-libs/log4cpp
	x11-libs/qcairo[X,opengl]
	media-libs/celt:5
	media-video/ffmpeg
	media-libs/alsa-lib
	dev-libs/openssl
	virtual/glu
	>=x11-libs/libXrandr-1.2
	>=sys-devel/gcc-4.1"
DEPEND="${COMMON_DEP}
	dev-util/pkgconfig
	sys-devel/libtool"

RDEPEND="${COMMON_DEP}"

S="${WORKDIR}/${PN}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static static-linkage) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failded"
	dodoc AUTHORS ChangeLog NEWS README
}
