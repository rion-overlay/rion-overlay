# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Commiter: AntiXpucT <i.am@antixpuct.ru>. Author: ipse <ipse1@yandex.ru>. Rion's Overlay.$

inherit subversion qt4 eutils

DESCRIPTION="Lightweight media player based on Qt and Gstreamer"
HOMEPAGE="http://code.google.com/p/cueplayer/"

ESVN_REPO_URI="http://cueplayer.googlecode.com/svn/trunk/"
ESVN_PROJECT="cueplayer-svn"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="x11-libs/qt-core
        x11-libs/qt-gui
        media-libs/gstreamer
        media-libs/gst-plugins-base"
RDEPEND="${DEPEND}"

src_unpack()
{
        subversion_src_unpack
}

src_compile() {
        eqmake4 cueplayer.pro "PREFIX=/usr"
        emake
}

src_install() {
        emake INSTALL_ROOT="${D}" install || die "make install failed"
        dodoc CHANGELOG README || die "dodoc failed"
        newicon "images/knotify.png" cueplayer.png
        make_desktop_entry cueplayer "CuePlayer" cueplayer "Qt;AudioVideo;Player"
}