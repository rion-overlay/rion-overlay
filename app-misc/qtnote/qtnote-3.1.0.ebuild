# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

case "$PV" in 9999*) scm=git-r3; ;; *) scm=""; ;; esac

inherit qmake-utils gnome2-utils $scm

DESCRIPTION="Qt note-taking application compatible with tomboy"
HOMEPAGE="http://ri0n.github.io/QtNote/"
if [ -z "$scm" ]; then
	SRC_URI="https://github.com/Ri0n/QtNote/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/QtNote-${PV}"
	KEYWORDS="amd64 x86"
else
	EGIT_REPO_URI="https://github.com/Ri0n/QtNote"
	EGIT_BRANCH=stable
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="spell kde unity"

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsingleapplication[X]
	kde? (
		kde-frameworks/kglobalaccel
		kde-frameworks/kwindowsystem
		kde-frameworks/knotifications )
	spell? ( app-text/hunspell )"
RDEPEND="${DEPEND}"

pkg_setup() {
	CONF=( PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" )
	use spell || CONF+=( CONFIG+=nospellchecker )
	use kde || CONF+=( CONFIG+=nokde )
	use unity || CONF+=( CONFIG+=noubuntu )
}

src_configure() {
	eqmake5 ${PN}.pro ${CONF[@]}

}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
