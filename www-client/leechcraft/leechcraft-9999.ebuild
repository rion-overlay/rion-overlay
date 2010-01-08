# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://github.com/0xd34df00d/leechcraft.git"
inherit python git cmake-utils confutils

DESCRIPTION="Opensource network client providing a full-featured web browser, BitTorrent client and much more."
HOMEPAGE="http://leechcraft.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="kde +browser +torrent +rss -nufella +dbus lyrics +history
	+mediaplayer +irc +networkmonitor +newlife sqlite +opensearch debug +ftp
	+directconnect postgres sitedownloader +vgrabber python text_editor"
# browser torrent rss/agregator nufella bdus
DEPEND="app-arch/bzip2
		>=dev-libs/boost-1.39
		>=x11-libs/qt-core-4.6
		>=x11-libs/qt-gui-4.6
		>=x11-libs/qt-sql-4.6
		>=x11-libs/qt-script-4.6
		>=x11-libs/qt-svg-4.6
		>=x11-libs/qt-xmlpatterns-4.6
		>=x11-libs/qt-script-4.6
		>=x11-libs/qt-sql-4.6[postgres?,sqlite?]
		dbus? ( x11-libs/qt-dbus )
		net-misc/curl
		torrent? ( =net-libs/rb_libtorrent-0.15*[crypt] )
		mediaplayer? ( media-sound/phonon )
		browser? ( >=x11-libs/qt-webkit-4.6 )
		python? ( dev-python/PythonQt )"
RDEPEND="${DEPEND}"

pkg_setup() {
	confutils_require_any postgres sqlite
	use python && python_need_rebuild
}
src_unpack() {
	git_src_unpack
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	local mycmakeargs="-DENABLE_HTTP=ON"
	mycmakeargs="${mycmakeargs}
				$(cmake-utils_use_enable browser POSHUKU)
				$(cmake-utils_use_enable torrent TORRENT)
				$(cmake-utils_use_enable rss AGGREGATOR)
				$(cmake-utils_use_enable nufella NUFELLA)
				$(cmake-utils_use_enable dbus DBUSMANAGER)
				$(cmake-utils_use_enable lyrics DEADLYRICS)
				$(cmake-utils_use_enable history HISTORYHOLDER)
				$(cmake-utils_use_enable mediaplayer LMP)
				$(cmake-utils_use_enable networkmonitor NETWORKMONITOR)
				$(cmake-utils_use_enable opensearch SEEKTHRU)
				$(cmake-utils_use_enable irc CHATTER)
				$(cmake-utils_use_enable ftp FTP)
				$(cmake-utils_use_enable directconnect DCMINATOR)
				$(cmake-utils_use_enable sitedownloader YASD)
				$(cmake-utils_use_enable kde ANHERO)
				$(cmake-utils_use_enable vgrabber VGRABBER)
				$(cmake-utils_use_enable newlife NEWLIFE)
				$(cmake-utils_use_enable python PyLC)
				$(cmake-utils_use_enable text_editor POC)"
	[ "$(get_libdir)" = "lib64" ] && mycmakeargs="${mycmakeargs}
				-DRESPECTLIB64=True"
	S="${WORKDIR}/${P}/src"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon resources/leechcraft.png
	make_desktop_entry leechcraft "LeechCraft" leechcraft.png
}
