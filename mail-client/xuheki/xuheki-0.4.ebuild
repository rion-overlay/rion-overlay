# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils webapp depend.apache multilib

MY_PN="Xuheki"

DESCRIPTION="Xuheki is a fast web-based IMAP written in Perl"
HOMEPAGE="http://www.xuheki.com"
SRC_URI="http://www.xuheki.com/download/"${PV}"/"${MY_PN}"-"${PV}".tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="mta"

RDEPEND="${DEPEND}"
DEPEND=">=virtual/mysql-5
		www-servers/apache
		dev-lang/perl
		www-apache/mod_perl
		mta? ( virtual/mta )
		dev-perl/Apache-Session-Wrapper
		dev-perl/DBIx-OO
		dev-perl/Net-IMAP-Client
		dev-perl/Regexp-Common-Email-Address
		dev-perl/Template-Alloy"

S="${WORKDIR}"/"${MY_PN}"-"${PV}"

src_install() {

	webapp_src_preinst
	
	dodir /var/log/"${MY_PN}"
	for i in captcha-cache sites-enabled ; do
			dodir /var/lib/"${MY_PN}"/"${i}"
	done
	
	dosym /var/log/"${MY_PN}" /var/log/"${MY_PN}"/logs
	doinitd "${FILESDIR}"/xuheki-0.4
}

msg_1() {
		einfo "Xuheki can run under a certain URL so there's no need to dedicate the"
		einfo "to it, but we still need to know the domain name."
		ebeep 5
		epause 5
}
