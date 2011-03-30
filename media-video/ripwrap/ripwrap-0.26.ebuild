# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit perl-app

DESCRIPTION="gtk-perl wrapper for mencoder and mp4box with scripting support"
HOMEPAGE="http://sourceforge.net/projects/ripwrap/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac mp2 mp3 x264 mp4"

DEPEND="dev-perl/gtk2-perl
		>=media-video/lsdvd-0.10
		media-video/mplayer[encode,aac?,mp2?,mp3?,x264?]
		mp4? ( media-video/gpac )"

RDEPEND=${DEPEND}

S="${WORKDIR}"/"${PN}"
SRC_TEST="do"
