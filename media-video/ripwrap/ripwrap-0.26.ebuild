# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit perl-app

DESCRIPTION="gtk-perl wrapper for mencoder and mp4box with scripting support"
HOMEPAGE="http://sourceforge.net/projects/ripwrap/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="aac mp2 mp3 x264 mp4"

DEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	>=media-video/lsdvd-0.10
	media-video/mplayer[encode]
	aac? ( media-video/mplayer[aac] )
	mp2? ( media-video/mplayer[mp2] )
	mp3? ( media-video/mplayer[mp3] )
	mp4? ( media-video/gpac )
	x264? ( media-video/mplayer[x264] )"
RDEPEND=${DEPEND}

S="${WORKDIR}"/"${PN}"
SRC_TEST="do"

