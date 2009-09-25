# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils

RESTRICT="mirror"
SRC_URI="http://downloads.sourceforge.net/project/leechcraft/LeechCraft/${PV}/${P}-source.tar.bz2"

DESCRIPTION="Opensource network client providing a full-featured web browser, BitTorrent client and much more."
HOMEPAGE="http://leechcraft.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+browser +torrent rss +dbus lyrics history
	mediaplayer networkmonitor +opensearch debug"

DEPEND=">=dev-libs/boost-1.37
		>=x11-libs/qt-gui-4.5.1
		>=x11-libs/qt-core-4.5.1
		>=x11-libs/qt-sql-4.5.1
		>=x11-libs/qt-script-4.5.1
		>=x11-libs/qt-svg-4.5.1
		torrent? ( =net-libs/rb_libtorrent-9999[crypt] )
		lmp? ( media-sound/phonon )
		poshuku? ( >=x11-libs/qt-webkit-4.5.1 )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}/src"

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
				$(cmake-utils_use_enable dbus DBUSMANAGER)
				$(cmake-utils_use_enable lyrics DEADLYRICS)
				$(cmake-utils_use_enable history HISTORYHOLDER)
				$(cmake-utils_use_enable mediaplayer LMP)
				$(cmake-utils_use_enable networkmonitor NETWORKMONITOR)
				$(cmake-utils_use_enable opensearch SEEKTHRU)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon resources/leechcraft.png
	make_desktop_entry leechcraft "LeechCraft" leechcraft.png
}
