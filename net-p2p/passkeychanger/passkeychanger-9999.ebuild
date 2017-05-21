# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils git-r3

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
