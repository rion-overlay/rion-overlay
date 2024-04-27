# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

case "$PV" in 9999*) scm=git-r3; ;; *) scm=""; ;; esac

inherit cmake $scm # xdg

DESCRIPTION="Qt note-taking application compatible with tomboy"
HOMEPAGE="http://ri0n.github.io/QtNote/"
if [ -z "$scm" ]; then
	SRC_URI="https://github.com/Ri0n/QtNote/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/QtNote-${PV}"
	KEYWORDS="amd64 x86"
else
	EGIT_REPO_URI="https://github.com/Ri0n/QtNote"
	EGIT_BRANCH=master
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="spell kde qt6 unity"

DEPEND="
	qt6? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsingleapplication[X]
		kde? (
			kde-frameworks/kglobalaccel:5
			kde-frameworks/kwindowsystem:5
			kde-frameworks/knotifications:5 )
	)
	!qt6? (
		dev-qt/qtbase:6[gui,widgets,network]
		kde? (
			kde-frameworks/kglobalaccel:6
			kde-frameworks/kwindowsystem:6
			kde-frameworks/knotifications:6 )
	)
	spell? ( app-text/hunspell )"
RDEPEND="${DEPEND}"

qtnote_plugin_enable() {
	echo -DQTNOTE_PLUGIN_ENABLE_${2:-$1}=$(usex "$1")
}

src_prepare() {
	#xdg_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(qtnote_plugin_enable spell spellchecker)
		$(qtnote_plugin_enable kde kdeintegration)
		$(qtnote_plugin_enable unity ubuntu)
		-DQT_DEFAULT_MAJOR_VERSION=$(usex qt6 6 5)
	)
	cmake_src_configure
}
