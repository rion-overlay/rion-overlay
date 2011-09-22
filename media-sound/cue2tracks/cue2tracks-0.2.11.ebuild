# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

DESCRIPTION="Bash script for split audio CD image files with cue sheet to tracks and write tags."
HOMEPAGE="http://cyberdungeon.org.ru/~killy/projects/cue2tracks/"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac +flac flake mac mp3 mp4 shorten tta vorbis wavpack"

RDEPEND="
	app-shells/bash
	app-cdr/cuetools
	>=media-sound/shntool-3.0.0[mac?]
	sys-apps/file
	virtual/libiconv
	aac? ( media-libs/faac media-libs/faad2 )
	flac? ( media-libs/flac )
	flake? ( media-sound/flake )
	mac? ( media-sound/mac media-sound/apetag )
	mp3? ( media-sound/lame media-sound/id3v2 )
	mp4? ( media-libs/libmp4v2[utils] )
	shorten? ( media-sound/shorten )
	tta? ( media-sound/ttaenc )
	vorbis? ( media-sound/vorbis-tools )
	wavpack? ( media-sound/wavpack media-sound/apetag )
"

src_prepare () {
	epatch "${FILESDIR}/remove_shell_check.patch"
}

src_install() {
	dobin "${PN}"
	dodoc AUTHORS ChangeLog README TODO
}
