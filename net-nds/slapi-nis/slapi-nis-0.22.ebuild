# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils confutils

DESCRIPTION="NIS plugin 389 (FDS) server"
HOMEPAGE="https://fedorahosted.org/slapi-nis"
SRC_URI="https://fedorahosted.org/releases/s/l/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="389 asyncns +openldap tcpd tirpc"

DEPEND="net-nds/389-ds-base
		tirpc? ( net-libs/libtirpc )
		tcpd? ( sys-apps/tcp-wrappers )
		asyncns? ( net-libs/libasyncns )
		openldap? ( net-nds/openldap )
		389? ( dev-libs/mozldap )"

RDEPEND="${DEPEND}"

pkg_setup() {
	confutils_require_one 389 openldap
	confutils_use_conflict 389 openldap
}

src_prepare() {
	eautoreconf
}

src_configure() {

	use 389 && myconf="mozldap"
	use openldap && myconf="openldap"

	econf \
	--with-server=dirsrv \
	--with-ldap=${myconf} \
	$(use_with tirpc) \
	$(use_with tcpd tcp-wrappers) \
	$(use_with asyncns) || die
}

src_test() {
	emake check || die
}

src_install() {
	emake DESTDIR="${ED}"  install || die

	nonfatal dodoc -r  doc/

	nonfatal dodoc NEWS README STATUS
}
