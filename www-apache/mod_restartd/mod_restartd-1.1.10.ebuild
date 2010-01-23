# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"
MY_PV="1.1.10.a3"
inherit apache-module autotools

KEYWORDS="~amd64 ~x86"

DESCRIPTION="An Apache 2.0 module for doing suid CGIs."
HOMEPAGE="http://port389.org"
SRC_URI="http://port389.org/sources/389-admin-${MY_PV}.tar.bz2"

LICENSE="Apache-1.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

#S="${WORKDIR}/389-admin-${MY_PV}/${PN}"
APXS2_S="${WORKDIR}/389-admin-${MY_PV}/${PN}"
APACHE2_MOD_CONF="48_${PN}"
APACHE2_MOD_DEFINE="RESTARTD"
DOCFILES="README"


need_apache2

src_prepare() {
	
	cd "${WORKDIR}/389-admin-${MY_PV}"
	eautoreconf

}

isrc_configure() {
	econf --with-apxs=${APXS} \
	|| die "econf failed"
}

isrc_compile() {
	emake || die
}
