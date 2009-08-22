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
KEYWORDS=""
IUSE="mta"

RDEPEND="${DEPEND}"
DEPEND=">=virtual/mysql-5
		dev-lang/perl[ithreads]
		www-servers/apache
		www-apache/libapreq2
		www-apache/mod_perl
		mta? ( virtual/mta )
		dev-perl/Apache-Session-Wrapper
		dev-perl/DBIx-OO
		dev-perl/Net-IMAP-Client
		dev-perl/Regexp-Common-Email-Address
		dev-perl/Template-Alloy
		dev-perl/Apache-Session-Wrapperi
		dev-perl/libwww-perl[ssl]
		dev-perl/IO-Socket-SSL
		dev-perl/DateTime-Format-Mail
		dev-perl/Regexp-Common-Email-Address
		dev-perl/POE[libwww]
		>=dev-perl/Data-FormValidator-4.63
		dev-perl/GD [ gif, jpeg, png, truetype]
		dev-perl/GD-SecurityImage
		dev-perl/Log-Log4perl
		dev-perl/Crypt-Rijndael
		dev-perl/Email-MIME-Encodings"

S="${WORKDIR}"/"${MY_PN}"-"${PV}"

src_install() {

	webapp_src_preinst
	
	dodir /var/log/"${MY_PN}"
	for i in captcha-cache sites-enabled ; do
			dodir /var/lib/"${MY_PN}"/"${i}"
	done
	
	dosym /var/log/"${MY_PN}" /var/log/"${MY_PN}"/logs
	doinitd "${FILESDIR}"/xuheki-0.4
	  einfo "Installing web files"
	      cd "${S}"/docroot
		      cp -R . "${D}"/"${MY_HTDOCSDIR}"

}



pkg_setup() {
webapp_pkg_setup
}

msg_1() {
		einfo "Xuheki can run under a certain URL so there's no need to dedicate the"
		einfo "to it, but we still need to know the domain name."
		ebeep 5
		epause 5
}
