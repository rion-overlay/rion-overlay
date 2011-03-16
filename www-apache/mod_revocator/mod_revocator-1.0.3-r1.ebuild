# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit apache-module autotools multilib

DESCRIPTION="Apache 2 module that lets the user configure remote CRL"
HOMEPAGE="http://directory.fedoraproject.org/wiki/Mod_revocator"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
LICENSE="Apache-2.0"

ALLDEPEND="dev-libs/nss[revocator]
		dev-libs/nspr
		net-nds/openldap
		www-apache/mod_nss"

DEPEND="sys-devel/bison
		sys-devel/flex
		dev-util/pkgconfig
		${ALLDEPEND}"

RDEPEND="${ALLDEPEND}"
need_apache2_2
APACHE2_MOD_FILE=".libs/libmodrev.so"

src_prepare() {
	epatch "${FILESDIR}"/respect_ldflags.patch || die
	eautoreconf
}

src_configure() {

	econf \
	--enable-openldap  || die ""
}

src_compile() {
	# not use apache-module.eclass build
	emake ||die
}

src_install() {
	make DESTDIR="${D}" install || die
	dohtml docs/mod_revocator.html
	dodoc AUTHORS ChangeLog README

	rm "${D}"/usr/$(get_libdir)/libmodrev.so || die
	rm "${D}"/usr/$(get_libdir)/librevocation.a || die
	#delete la files
	find "${D}"/usr/$(get_libdir) -name \*.la -delete

	apache-module_src_install
}
