# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp depend.php depend.apache

DESCRIPTION="SmartSieve is a web based user interface for managing Sieve scripts on a Cyrus imap mail server."
HOMEPAGE="http://smartsieve.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}/${PN}-1.0-RC2/${PN}-1.0-RC2.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/php:5[imap,crypt,iconv,session]
		dev-php/PEAR-Crypt_RC4
		dev-php/PEAR-Log"
RDEPEND="${DEPEND}"

need_php5_httpd
need_apache2_2
S="${WORKDIR}/${PN}"-1.0-rc2
pkg_setup() {
	webapp_pkg_setup

	local flag="imap crypt iconv session"
	if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} ; then
		die "Re-install ${PHP_PKG} with ${flags} and either gd or gd-external"
	fi
}
src_install() {

	dodoc ChangeLog CHANGES INSTALL NOTICE README TODO

	for i in ChangeLog CHANGES INSTALL NOTICE README TODO COPYING;
		do
			rm "${S}"/$i || die
		done

	webapp_src_preinst
	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/conf/.htaccess
	webapp_configfile "${MY_HTDOCSDIR}"/conf/config.php
	webapp_configfile "${MY_HTDOCSDIR}"/scripts/.htaccess
	webapp_postinst_txt en "${FILESDIR}"/postinstall.en.txt
	webapp_src_install
}
