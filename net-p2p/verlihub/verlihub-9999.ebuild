# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

CMAKE_MIN_VERSION="2.6"
PYTHON_DEPEND="python? 2:2.6"

inherit git-2 cmake-utils python

DESCRIPTION="VerliHub is a Direct Connect protocol server (Hub)"
HOMEPAGE="http://www.verlihub-project.org"
EGIT_REPO_URI="git://verlihub.git.sourceforge.net/gitroot/verlihub/verlihub"
EGIT_PROJECT="verlihub/verlihub"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="geoip +forbid chatroom +iplog isp +plugman messenger stats replacer floodprot python lua debug"

DEPEND="dev-libs/libpcre
	geoip? ( dev-libs/geoip )
	>=virtual/mysql-5.1
	>=dev-lang/lua-5.1
	dev-libs/libpcre
	sys-devel/gettext
	dev-libs/openssl
	sys-libs/zlib
	dev-libs/libpcre
	dev-util/dialog"

RDEPEND="
	${DEPEND}
	!net-libs/lua
	!net-libs/iplog
	!net-libs/forbid
	!net-libs/messanger
	!net-libs/chatroom
	!net-libs/isp
	!net-libs/replacer
	!net-libs/stats
	!net-libs/python"

DOCS=(INSTALL TODO)

pkg_setup() {
	if use python; then
		python_pkg_setup
		python_set_active_version 2
		python_need_rebuild
	fi
}

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with geoip GEOIP)
		$(cmake-utils_use_with plugman PLUGMAN)
		$(cmake-utils_use_with lua  LUA)
		$(cmake-utils_use_with python PYTHON)
		$(cmake-utils_use_with forbid FORBID)
		$(cmake-utils_use_with chatroom CHATROOM)
		$(cmake-utils_use_with iplog IPLOG)
		$(cmake-utils_use_with isp ISP)
		$(cmake-utils_use_with messenger MESSENGER)
		$(cmake-utils_use_with stats STATS)
		$(cmake-utils_use_with replacer REPLACER)
		$(cmake-utils_use_with floodprot FLOODPROT)
		)
	cmake-utils_src_configure
}
