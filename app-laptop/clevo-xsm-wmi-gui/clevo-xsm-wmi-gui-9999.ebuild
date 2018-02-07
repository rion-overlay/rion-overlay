# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils git-r3

DESCRIPTION="An app for some Clevo P15xSM(1)(-A)/P17xSM(-A)/P370SM-A Laptop models"
HOMEPAGE="https://bitbucket.org/tuxedocomputers/clevo-xsm-wmi"
EGIT_REPO_URI="https://bitbucket.org/tuxedocomputers/clevo-xsm-wmi.git"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS=""
IUSE="systemd"

DEPEND="
    app-laptop/clevo-xsm-wmi
    dev-qt/qtwidgets
"
RDEPEND=""

S="${WORKDIR}/${P}/utility"

src_configure() {
    eqmake5 clevo-xsm-wmi.pro
}

src_install() {
    dobin clevo-xsm-wmi
}
