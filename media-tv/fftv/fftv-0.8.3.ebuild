# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Watch TV, Listen radio with video/audio capture"
HOMEPAGE="http://fftv.sourceforge.net/"
SRC_URI="mirror://sourceforge/fftv/${P}.tar.bz2"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="zlib mmx v4l vorbis oss lirc mp3"

DEPEND=">=x11-libs/gtk+-2
	lirc? ( app-misc/lirc )"
RDEPEND=""

src_compile() {
	econf \
		--prefix=/usr \
		$(use_enable zlib) \
		$(use_enable mmx) \
		$(use_enable v4l) \
		$(use_enable vorbis) \
		$(use_enable mp3 mp3lame) \
		$(use_enable oss audio-oss) \
		${myconf} || die
	emake || die "Make failed!"
}

src_install() {
	exeinto /usr/bin
	doexe ffmpeg-fftv ffplay-fftv ffserver-fftv fftv/reminder fftv/fftv fftv/ffradio fftv/ffrecord

	dodir /usr/lib/fftv
	insinto /usr/lib/fftv/X11
	doins fftv/key-map/fftv_xkey.map
	insinto /usr/lib/fftv/conf
	doins fftv/conf/codecs-radio fftv/conf/codecs-tv fftv/conf/conf-radio fftv/conf/conf-tv
	insinto /usr/lib/fftv/lirc
	doins fftv/key-map/lirc/*

	dodir /usr/lib/vhook
	insinto /usr/lib/vhook
	doins vhook/*.so
	fperms 755 /usr/lib/vhook/*

	#install fftv icons
	dodir /usr/share/icons/fftv
	insinto /usr/share/icons/fftv
	doins fftv/icons/*
	insinto /usr/share/icons
	doins fftv/icons/fftv.png

	#install fftv and ffradio menu entry
	#insinto /usr/share/applications
	#doins ${FILESDIR}/fftv.desktop ${FILESDIR}/ffradio.desktop
	make_desktop_entry ffradio "FFRadio" fftv.png
	make_desktop_entry fftv "FFTV" fftv.png

	dodoc Changelog Changelog.fftv README CREDITS CREDITS.fftv
	doman doc/*.1
	dohtml -r doc/*.html
}
