# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_REPO_URI="git://github.com/0xd34df00d/leechcraft.git"
EGIT_PROJECT="leechcraft-${PV}"

inherit confutils leechcraft

DESCRIPTION="Core of LeechCraft, the modular network client providing a browser, BitTorrent client and much more."

IUSE="debug +sqlite postgres"
DEPEND=">=dev-libs/boost-1.39
		>=x11-libs/qt-core-4.6
		>=x11-libs/qt-gui-4.6
		>=x11-libs/qt-script-4.6
		>=x11-libs/qt-sql-4.6[postgres?,sqlite?]"
RDEPEND="${DEPEND}
		>=x11-libs/qt-svg-4.6
		!www-client/leechcraft"

pkg_setup() {
	confutils_require_any postgres sqlite
}

src_configure() {
	if use debug ; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Release"
	fi
	local mycmakeargs="-DENABLE_HTTP=OFF
		-DENABLE_POSHUKU=OFF
		-DENABLE_TORRENT=OFF
		-DENABLE_AGGREGATOR=OFF
		-DENABLE_NUFELLA=OFF
		-DENABLE_DBUSMANAGER=OFF
		-DENABLE_DEADLYRICS=OFF
		-DENABLE_HISTORYHOLDER=OFF
		-DENABLE_LMP=OFF
		-DENABLE_NETWORKMONITOR=OFF
		-DENABLE_SEEKTHRU=OFF
		-DENABLE_CHATTER=OFF
		-DENABLE_FTP=OFF
		-DENABLE_EISKALTDCPP=OFF
		-DENABLE_YASD=OFF
		-DENABLE_ANHERO=OFF
		-DENABLE_KINOTIFY=OFF
		-DENABLE_VGRABBER=OFF
		-DENABLE_NEWLIFE=OFF
		-DENABLE_PYLC=OFF
		-DENABLE_POC=OFF
		-DENABLE_AUSCRIE=OFF
		-DENABLE_SUMMARY=OFF
		-DENABLE_TABPP=OFF
		-DENABLE_SECMAN=OFF
		-DENABLE_QROSP=OFF
		-DENABLE_POPISHU=OFF"
	cmake-utils_src_configure
}

src_install() {
	leechcraft_src_install
	make_desktop_entry leechcraft "LeechCraft" leechcraft.png
}
