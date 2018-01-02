# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN="msx264"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="mediastreamer plugin: add H264 support"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://www.linphone.org/releases/sources/plugins/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libav"

RDEPEND=">=media-libs/mediastreamer-2.7.0:=[video]
	>=media-libs/x264-0.0.20100118:=
	libav? ( media-video/libav:0= )
	!libav? ( media-video/ffmpeg:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=OFF
	)
	cmake-utils_src_configure
}
