# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Qt4 torrent passkey changer"
HOMEPAGE="http://panter-dsd.github.com/PasskeyChanger"
EGIT_REPO_URI="git://github.com/panter-dsd/PasskeyChanger.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug"

RDEPEND="dev-qt/qtgui:4"
DEPEND="${RDEPEND}"

src_install() {
	dobin "${CMAKE_BUILD_DIR}"/${PN}
}
