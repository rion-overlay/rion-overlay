# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils git-r3

DESCRIPTION="String representation converter (text, cpp, json)"
HOMEPAGE="https://github.com/Ri0n/cpp2text"
EGIT_REPO_URI="https://github.com/Ri0n/cpp2text"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-qt/qtgui:5"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
