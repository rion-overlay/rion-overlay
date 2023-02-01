# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils git-r3 gnome2-utils

DESCRIPTION="Powerful UML 2 modelling tool. BoUML fork"
HOMEPAGE="https://github.com/DoUML/douml"
EGIT_REPO_URI="https://github.com/DoUML/douml.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtsql:5"
RDEPEND="${DEPEND}"

pkg_setup() {
	export QT_SELECT=5
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
