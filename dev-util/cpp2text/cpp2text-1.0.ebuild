# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Stupid bidirection cpp to text converter"
HOMEPAGE="https://github.com/Ri0n/cpp2text"
SRC_URI="https://github.com/Ri0n/cpp2text/archive/1.0.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-qt/qtgui:5"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr" ${PN}.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}

