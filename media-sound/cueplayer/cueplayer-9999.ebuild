# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Commiter: AntiXpucT <i.am@antixpuct.ru>. Author: ipse <ipse1@yandex.ru>. Rion's Overlay.$

EAPI=2
inherit qt4-r2 subversion eutils

DESCRIPTION="Lightweight media player based on Qt and Gstreamer"
HOMEPAGE="http://code.google.com/p/cueplayer/"
ESVN_REPO_URI="http://cueplayer.googlecode.com/svn/trunk/"
ESVN_PROJECT="cueplayer-svn"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="mp3enc bad ugly"

DEPEND="x11-libs/qt-core
	x11-libs/qt-gui
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-plugins/gst-plugins-ffmpeg
	media-plugins/gst-plugins-flac
	bad? ( media-libs/gst-plugins-bad )
	ugly? ( media-libs/gst-plugins-ugly )
	mp3enc? ( media-plugins/gst-plugins-lame media-plugins/gst-plugins-taglib )"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake4 PREFIX="/usr"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"
	dodoc CHANGELOG README || die "dodoc failed"
	newicon "images/knotify.png" cueplayer.png
	make_desktop_entry cueplayer "CuePlayer" cueplayer "Qt;AudioVideo;Player"
}