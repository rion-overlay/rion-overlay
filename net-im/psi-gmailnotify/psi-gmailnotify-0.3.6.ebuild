# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4

MY_PN="gmailnotifyplugin"

DESCRIPTION="Gmail notify plugin for psi"
HOMEPAGE="http://vampirus.ru/projects/psi/"
SRC_URI="http://vampirus.ru/projects/psi/gmailnotifyplugin/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/psi[plugins]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	sed 's/\.\.\/\.\.\/psiplugin.pri/\/usr\/share\/psi\/plugins\/psiplugin.pri/' \
		-i "${MY_PN}".pro
	eqmake4 "${MY_PN}".pro DESTDIR="${D}/usr/$(get_libdir)/psi/plugins"
	emake || die "Make failed"
}

