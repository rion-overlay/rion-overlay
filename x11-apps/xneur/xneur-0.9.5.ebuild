# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="In-place conversion of text typed in with a wrong keyboard layout (Punto Switcher replacement)"
HOMEPAGE="http://www.xneur.ru/"
if [[ "${PV}" = 9999 ]] ; then
	inherit subversion autotools
	SRC_URI=""
	ESVN_REPO_URI="svn://xneur.ru:3690/xneur/${PN}"
else
	SRC_URI="http://dists.xneur.ru/release-${PV}/tgz/${P}.tar.bz2"
fi
LICENSE="GPL-2"
IUSE="spell pcre gstreamer openal aplay xpm debug"
SLOT="0"

KEYWORDS="~x86 ~amd64"
RDEPEND=">=x11-libs/libX11-1.1
	media-libs/imlib2
	x11-libs/xosd
	x11-libs/libXtst
	xpm? ( x11-libs/libXpm )
	gstreamer? ( >=media-libs/gstreamer-0.10.6 )
	!gstreamer? ( openal? ( >=media-libs/freealut-1.0.1 )
				  !openal? ( aplay? ( media-sound/alsa-utils ) ) )
	pcre? ( >=dev-libs/libpcre-5.0 )
	spell? ( app-text/aspell )"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.20"

src_unpack() {
	if [[ ${SRC_URI} == "" ]] ; then
		subversion_src_unpack
		cd "${S}"

		sed -i -e 's/-Werror//' configure.in
		eautoreconf
	else
		unpack ${A}
		cd "${S}"

		AT_M4DIR="m4" eautoreconf
	fi
}

src_compile() {
	local myconf
	if use gstreamer; then
		myconf="--with-sound=gstreamer"
	elif use openal; then
		myconf="--with-sound=openal"
	elif use aplay; then
		myconf="--with-sound=aplay"
	else
		myconf="--with-sound=no"
	fi

	econf "${myconf}" \
		$(use_with spell aspell) \
		$(use_with debug) \
		$(use_with xpm) \
		$(use_with pcre) || die "configure failed"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc AUTHORS ChangeLog README NEWS TODO
}

pkg_postinst() {
	elog "This is command line tool. Take a look at kxner or gxneur for kde or"
	elog "gnome GUI front-ends respectively."
}
