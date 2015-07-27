# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit qmake-utils git-2

DESCRIPTION="Qt note-taking application compatible with tomboy"
HOMEPAGE="http://ri0n.github.io/QtNote/"
EGIT_REPO_URI="https://github.com/Ri0n/QtNote"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+qt4 qt5 spell kde unity"
REQUIRED_USE="^^ ( qt4 qt5 )"

DEPEND="
	qt4? ( dev-qt/qtgui:4
	       dev-qt/qtsingleapplication[X,qt4] )
	qt5? ( dev-qt/qtgui:5
		   dev-qt/qtwidgets
		   dev-qt/qtnetwork:5
		   dev-qt/qtprintsupport:5
	       dev-qt/qtsingleapplication[X,qt5] )
	spell? ( app-text/hunspell )"
RDEPEND="${DEPEND}"

pkg_setup() {
	CONF=( PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/$(get_libdir)" )
	use spell || CONF+=( CONFIG+=nospellchecker )
	use kde || CONF+=( CONFIG+=nokde )
	use unity || CONF+=( CONFIG+=noubuntu )
}

src_configure() {
	use qt4 && eqmake4 ${PN}.pro ${CONF[@]}
	use qt5 && eqmake5 ${PN}.pro ${CONF[@]}

}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
