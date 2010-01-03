# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: media-sound/guayadeque/guayadeque-0.2.1.ebuild 2009/11/27 01:30:00 lukyn Exp $

EAPI="2"

inherit cmake-utils subversion

DESCRIPTION="Music player with the aims to be intuitive, easy to use and fast for even huge music collections"
HOMEPAGE="http://sourceforge.net/projects/guayadeque/"
ESVN_REPO_URI="https://guayadeque.svn.sourceforge.net/svnroot/guayadeque/Trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="x11-libs/wxGTK:2.8
	media-libs/taglib
	dev-db/sqlite:3
	media-libs/gstreamer:0.10
	sys-apps/dbus
	net-misc/curl
	media-libs/flac
	media-libs/libmp4v2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	dev-util/cmake"

pkg_postinst()	{

einfo "A plugin for the music-applet is available for ppl using this great applet. With this you
can control guayadeque from it. You must put it where the music applets are. In
Gentoo the plugins are at /usr/lib/python2.x/site-packages/musicapplet/plugins/."

}
