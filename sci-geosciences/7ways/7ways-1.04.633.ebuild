# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="NaviKey's car navigation software"
HOMEPAGE="http://navikey.ru/"
SRC_URI="http://navikey.ru/files/7w/7ways.tar.gz"

LICENSE="EULA"
SLOT="$PVR"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-emulation/emul-linux-x86-xlibs
	app-emulation/emul-linux-x86-baselibs
	app-emulation/emul-linux-x86-soundlibs
	"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

QA_PREBUILT="/opt/${PF}/7ways"
src_install() {
	insinto /opt/${PF}
	doins -r  "${S}"/*

	exeinto /opt/${PF}
	doexe 7ways

	make_desktop_entry /opt/${PF}/7ways , 7ways
}
