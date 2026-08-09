# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="da en es_ES fr it nl_NL ru uk vi zh_TW"
PLOCALE_BACKUP="en"

case "$PV" in 9999*) scm=git-r3; ;; *) scm=""; ;; esac

inherit cmake plocale $scm # xdg

DESCRIPTION="Extendable note-taking app with rich text and synchronization"
HOMEPAGE="https://anykeep.net"
if [ -z "$scm" ]; then
	SRC_URI="https://github.com/Ri0n/AnyKeep/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/AnyKeep-${PV}"
	KEYWORDS="amd64 x86"
else
	EGIT_REPO_URI="https://github.com/Ri0n/AnyKeep"
	EGIT_BRANCH=master
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="cinnamon spell kde gnome xmpp"

DEPEND="
	!app-misc/qtnote
	app-crypt/qca
	dev-libs/qtkeychain
	dev-qt/qtbase:6[gui,widgets,network]
	kde? (
		kde-frameworks/extra-cmake-modules
		kde-frameworks/kglobalaccel:6
		kde-frameworks/kwindowsystem:6
		kde-frameworks/knotifications:6 )
	spell? ( app-text/hunspell )
	xmpp? (
		dev-libs/qcoro
		net-libs/qxmpp )"
RDEPEND="${DEPEND}"

qtnote_plugin_enable() {
	echo -DQTNOTE_PLUGIN_ENABLE_${2:-$1}=$(usex "$1")
}

src_unpack() {
	git-r3_src_unpack

	unset EGIT_BRANCH EGIT_COMMIT
	EGIT_CHECKOUT_DIR="${S}/qsourcehighlite" \
	EGIT_REPO_URI="https://github.com/Waqar144/QSourceHighlite.git" \
	git-r3_src_unpack
}

src_prepare() {
	#xdg_src_prepare
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(qtnote_plugin_enable spell spellchecker)
		$(qtnote_plugin_enable kde kdeintegration)
		$(qtnote_plugin_enable gnome)
		$(qtnote_plugin_enable xmpp xmpppubsub)
		-DANYKEEP_QSOURCEHIGHLITE_SOURCE_DIR="${S}/qsourcehighlite"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	remove_locale() {
		rm -f ${ED}/usr/share/${PN}/${PN}_$1.qm
	}
	plocale_for_each_disabled_locale remove_locale
}
