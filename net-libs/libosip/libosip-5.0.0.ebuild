# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools versionator

MY_PV=${PV%.?}-${PV##*.}
MY_PV=${PV}
MY_P=${PN}2-${MY_PV}
DESCRIPTION="a simple way to support the Session Initiation Protocol"
HOMEPAGE="https://www.gnu.org/software/osip/"
#SRC_URI="mirror://gnu/osip/${MY_P}.tar.gz"
SRC_URI="https://fossies.org/linux/privat/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="2/$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.3.0-out-source-build.patch"
	AT_M4DIR="scripts" eautoreconf
}

src_configure() {
	econf --enable-mt \
		$(use_enable test)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog FEATURES HISTORY README NEWS TODO
}
