# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Mediastreaming library for telephony application"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="http://www.linphone.org/releases/sources/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
# Many cameras will not work or will crash an application if mediastreamer2 is
# not built with v4l2 support (taken from configure.ac)
# TODO: run-time test for ipv6: does it really need ortp[ipv6] ?
IUSE="+alsa amr bindist bv16 coreaudio debug doc examples +filters g726 g729 gsm ilbc
	ipv6 jpeg libav matroska ntp-timestamp opengl opus +ortp oss pcap portaudio pulseaudio sdl
	silk +speex static-libs test theora tools upnp v4l video vpx x264 X"

REQUIRED_USE="|| ( oss alsa portaudio coreaudio pulseaudio )
	video? ( || ( opengl sdl X ) )
	theora? ( video )
	X? ( video )
	v4l? ( video )
	opengl? ( video )"

RDEPEND=">=net-libs/bctoolbox-0.6.0
	media-libs/bzrtp
	net-libs/libsrtp:0
	alsa? ( media-libs/alsa-lib )
	g726? ( >=media-libs/spandsp-0.0.6_pre1 )
	gsm? ( media-sound/gsm )
	matroska? ( >=media-libs/bcmatroska2-0.23 )
	opus? ( media-libs/opus )
	ortp? ( >=net-libs/ortp-1.0.2 )
	pcap? ( sys-libs/libcap )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	speex? ( media-libs/speex media-libs/speexdsp )
	upnp? ( net-libs/libupnp:0 )
	video? (
		libav? ( media-video/libav:0/11 )

		opengl? ( media-libs/glew:0
			virtual/opengl
			x11-libs/libX11 )
		v4l? ( media-libs/libv4l
			sys-kernel/linux-headers )
		theora? ( media-libs/libtheora )
		sdl? ( media-libs/libsdl[video,X] )
		X? ( x11-libs/libX11
			x11-libs/libXv ) )"

DEPEND="${RDEPEND}
	dev-util/intltool
	app-editors/vim-core
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	opengl? ( dev-util/xxdi )
	test? ( >=dev-util/cunit-2.1_p3[ncurses] )
	X? ( x11-base/xorg-proto )"

PDEPEND="amr? ( !bindist? ( media-plugins/mediastreamer-amr ) )
	g729? ( !bindist? ( media-libs/bcg729 ) )
	ilbc? ( media-plugins/mediastreamer-ilbc )
	video? ( x264? ( media-plugins/mediastreamer-x264 ) )
	silk? ( !bindist? ( media-plugins/mediastreamer-silk ) )"

src_prepare() {
	eapply_user

	# variable causes "command not found" warning and is not
	# needed anyway
	sed -i \
		-e 's/$(ACLOCAL_MACOS_FLAGS)//' \
		Makefile.am || die

	# respect user's CFLAGS
	sed -i \
		-e "s:-O2::;s: -g::" \
		configure.ac || die "patching configure.ac failed"

	# change default paths
	sed -i \
		-e "s:\(prefix/share\):\1/${PN}:" \
		configure.ac || die "patching configure.ac failed"

	# fix doc installation dir
	sed -i \
		-e "s:\$(pkgdocdir):\$(docdir):" \
		help/Makefile.am || die "patching help/Makefile.am failed"

	# fix html installation dir
	sed -i \
		-e "s:\(doc_htmldir=\).*:\1\$(htmldir):" \
		help/Makefile.am || die "patching help/Makefile.am failed"

	# linux/videodev.h dropped in 2.6.38
	sed -i \
		-e 's:linux/videodev.h ::' \
		configure.ac || die

	# break check for conflicts with polarssl (emdedtls is used instead anyway)
	sed -i \
		-e 's:sha1_update:sha1_update_XXX:' \
		configure.ac || die

	epatch \
		"${FILESDIR}/${PN}-underlinking.patch" \
		"${FILESDIR}/${PN}-xxd.patch" \
		"${FILESDIR}/${PN}-gitversion.patch" \
		"${FILESDIR}/${PN}-gitversion2.patch" # second one because of cmake

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_SHARED=ON
		-DENABLE_STATIC=$(usex static-libs)
		-DENABLE_DEBUG_LOGS=$(usex debug)
		-DENABLE_DOC=$(usex doc)
		-DENABLE_NON_FREE_CODECS=ON
		-DENABLE_PCAP=$(usex pcap)
		-DENABLE_STRICT=OFF
		-DENABLE_TOOLS=$(usex tools)
		-DENABLE_UNIT_TESTS=$(usex test)
		-DENABLE_SRTP=ON
		-DENABLE_SOUND=ON
		-DENABLE_G726=$(usex g726)
		-DENABLE_GSM=$(usex gsm)
		-DENABLE_BV16=$(usex bv16)
		-DENABLE_OPUS=$(usex opus)
		-DENABLE_SPEEX_CODEC=$(usex speex)
		-DENABLE_SPEEX_DSP=$(usex speex)
		-DENABLE_G729=$(usex g729)
		-DENABLE_G729B_CNG=$(usex g729)
		-DENABLE_VIDEO=$(usex video)
		-DENABLE_MKV=$(usex matroska)
		-DENABLE_JPEG=$(usex jpeg)
	)

	# Other options
	#	-DENABLE_FIXED_POINT=$(usex point)
	#	-DENABLE_RELATIVE_PREFIX=$(usex prefix)

	cmake-utils_src_configure
}

src_test() {
	default
	cd tester || die
	./mediastreamer2_tester || die
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins tester/*.c
	fi
}
