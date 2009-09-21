# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools apache-module

DESCRIPTION="Apache authentication module for Citadel Groupware Server users"
HOMEPAGE="http://sourceforge.net/projects/modauthcitadel/"
SRC_URI="mirror://sourceforge/modauthcitadel/mod_authn_citadel-0.99-BETA2.tar.gz"
LICENSE="GPL-3"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

S="${WORKDIR}/mod_authn_citadel-0.99-BETA2"

APXS2_S="${S}"
APACHE2_MOD_FILE="${APXS2_S}/.libs/libmod_authn_citadel.so.0.0.0"
APACHE2_MOD_CONF="95_mod_citadel"
APACHE2_MOD_DEFINE="CITADEL"
DOCFILES="README"

RDEPEND="dev-libs/openssl
		>=sys-libs/db-4.6"
DEPEND="${DEPEND}
		sys-devel/libtool"

need_apache2_2

src_prepare() {
	eautoreconf
}
src_configure() {
	econf  || die
}
src_compile() {

	emake CPPFLAGS=-I/usr/lib/openssl || die "emake failed"
}

pkg_postinst() {
	apache-module_pkg_postinst
}
