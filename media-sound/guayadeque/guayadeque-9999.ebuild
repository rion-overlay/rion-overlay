# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils subversion

DESCRIPTION="Music player with the aims to be intuitive, easy to use and fast for even huge music collections"
HOMEPAGE="http://sourceforge.net/projects/guayadeque/"
ESVN_REPO_URI="https://guayadeque.svn.sourceforge.net/svnroot/guayadeque/Trunk"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""

RDEPEND="x11-libs/wxGTK:2.8
	media-libs/taglib
	dev-db/sqlite:3
	media-libs/gstreamer:0.10
	sys-apps/dbus
	net-misc/curl
	media-libs/flac"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig
	dev-util/cmake"

# echo $(cat po/CMakeLists.txt | grep ADD_SUBDIRECTORY | sed 's#ADD_SUBDIRECTORY( \(\w\+\) )#\1#')
LANGS="es uk it de fr is nb th cz ru"
for l in $LANGS ; do
	IUSE="$IUSE linguas_${l}"
done

src_prepare() {
	for l in $LANGS ; do
		if use linguas_${l} ; then
			LANGS="${LANGS/${l}/}"
		fi
	done
	llangs=`echo $LANGS`
	re="${llangs// /\\|}"
	sed -i -e "/ADD_SUBDIRECTORY( \(${re}\) )/d" po/CMakeLists.txt
	base_src_prepare
}

pkg_postinst()	{

einfo "A plugin for the music-applet is available for ppl using this great applet. With this you
can control guayadeque from it. You must put it where the music applets are. In
Gentoo the plugins are at /usr/lib/python2.x/site-packages/musicapplet/plugins/."

}
