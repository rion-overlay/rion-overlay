# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module eutils

KEYWORDS="~amd64 ~x86"

DESCRIPTION="An Apache 2.0 module for doing suid CGIs."
HOMEPAGE="http://port389.org"
SRC_URI="http://port389.org/sources/389-admin-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/389-admin-${PV}/${PN}"

APACHE2_MOD_CONF="48_${PN}"
APACHE2_MOD_DEFINE="RESTARTD"

DOCFILES="README"

need_apache2

src_compile() {
	econf --with-apxs=${APXS} \
	|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	apache-module_src_install
}
