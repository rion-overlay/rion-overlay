# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN="SugarCE"
inherit webapp depend.php

DESCRIPTION="A complete CRM and groupware system for businesses of all sizes."
HOMEPAGE="http://www.sugarforge.org/"
SRC_URI="http://dl.sugarforge.org/${PN}/1${MY_PN}6.0Beta/${MY_PN}6.0beta/${MY_PN}-6.0.0beta1.zip"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="+curl imap +json +zlib +mysql freetds ldap mssql"

DEPEND="app-arch/unzip"
RDEPEND=">=dev-lang/php-5.2[mysql=,ssl,soap,unicode,xml,curl=,imap=,json=,zlib=,ldap=,mssql=,session]
	dev-php/PEAR-DB
	dev-php/PEAR-Cache_Lite
	dev-php/PEAR-Mail_Mime
	virtual/httpd-cgi
	freetds? ( >=dev-db/freetds-0.64
				mssql? ( >=dev-db/freetds-0.64[mssql] ) )
	mysql? ( >=dev-db/mysql-5.0.70 )"

S="${WORKDIR}"/"${MY_PN}"-"Full-6.0.0beta1"
need_php5_httpd
src_install () {
	webapp_src_preinst

	cd "${S}"
	einfo "Installing main files"
	cp -R . "${D}"/"${MY_HTDOCSDIR}"

	webapp_postinst_txt en "${FILESDIR}"/"postinstall-en.txt"

	webapp_configfile "${MY_HTDOCSDIR}"/"config.php"
	webapp_configfile "${MY_HTDOCSDIR}"/".htaccess"

	for foo in cache custom data modules include ; do
		webapp_serverowned -R "${MY_HTDOCSDIR}"/"${foo}"  || die
	done

	webapp_serverowned "${MY_HTDOCSDIR}"/"config.php"
	einfo "Please make adjustment of your php.ini or .htaccess file"
	einfo "Change value "seesion.path = "  according to your desire"
	einfo "Files of sessions are stored in this directory"
	einfo "For more info  see http://developers.sugarcrm.com/documentation.php "
	webapp_src_install
}
