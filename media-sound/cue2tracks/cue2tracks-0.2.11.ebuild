# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="Bash script for split audio CD image files with cue sheet to tracks and write tags."
HOMEPAGE="http://cyberdungeon.org.ru/~killy/projects/cue2tracks/"
SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="flake mac mp3 tta shorten wavpack vorbis"

SLOT="0"

DEPEND="flake? ( media-sound/flake )
	mac? ( media-sound/mac media-sound/apetag )
	tta? ( media-sound/ttaenc )
	shorten? ( media-sound/shorten )
	wavpack? ( media-sound/wavpack media-sound/apetag )
	mp3? ( media-sound/lame media-sound/id3v2 )
	vorbis? ( media-sound/vorbis-tools )"
RDEPEND=">=media-sound/shntool-3.0.0[mac?]
	app-shells/bash
	media-libs/flac
	app-cdr/cuetools"

src_prepare () {
	epatch "${FILESDIR}/remove_shell_check.patch"
}

src_install() {
	dobin "${PN}" || die
	dodoc AUTHORS ChangeLog README TODO
}

pkg_postinst() {
	echo ""
	einfo 'To get help about usage run "$ cue2tracks -h"'
	echo ""
}
