# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2:2.6"
WANT_AUTOMAKE="1.10"

inherit autotools python git

DESCRIPTION="Provide high-quality remote access to QEMU using SPICE protocol"
HOMEPAGE="http://www.spice-space.org http://www.redhat.com/virtualization/rhev"
#SRC_URI="http://www.spice-space.org/download/${P}.tar.bz2"
EGIT_REPO_URI="git://cgit.freedesktop.org/spice/spice"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="proxy gui opengl"

COMMON_DEP=">=x11-libs/pixman-0.17
	>=x11-apps/xrandr-1.2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/cairo[X,opengl]
	dev-libs/log4cpp
	media-libs/celt:5
	media-video/ffmpeg[jpeg2k]
	media-libs/alsa-lib
	dev-libs/openssl
	virtual/glu
	virtual/jpeg
	>=sys-devel/gcc-4.1
	app-emulation/spice-protocol
	gui? ( =dev-games/cegui-0.6* )
	proxy? ( net-libs/slirp )"
DEPEND="${COMMON_DEP}
	dev-util/pkgconfig
	sys-devel/libtool
	dev-python/pyparsing"

RDEPEND="${COMMON_DEP}"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	eautoreconf
}

src_configure() {
	local myconf=""
# Опять идиоты не освоили автотулсы ::::::(
	if use proxy;then
		myconf+=" --enable-tunnel "
	fi
	if use gui; then
		myconf+="  --enable-gui "
	fi

	if use opengl; then
		myconf+=" --enable-opengl "
	fi

	econf \
		${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS ChangeLog NEWS README
}
