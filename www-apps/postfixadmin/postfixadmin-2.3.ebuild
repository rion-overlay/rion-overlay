# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils webapp depend.php confutils

DESCRIPTION="Web Based Management tool for Postfix style virtual domains and users."
HOMEPAGE="http://high5.net/postfixadmin/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres +vacation addition env_password doc -xmlrpc"

DEPEND="vacation? ( dev-perl/DBI
		virtual/perl-MIME-Base64
		dev-perl/MIME-EncWords
		dev-perl/Email-Valid
		dev-perl/Mail-Sender
		dev-perl/log-dispatch
		dev-perl/Log-Log4perl
		dev-perl/MIME-Charset
		mysql? ( dev-perl/DBD-mysql )
		postgres? ( dev-perl/DBD-Pg ) )
		xmlrpc? ( dev-php5/ZendFramework[-minimal] )"

RDEPEND="${DEPEND}"

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup

	confutils_require_any mysql postgres

	local flags="session pcre unicode imap"
	use postgres && flags+=" postgres"
	use xmlrpc && flags+=" xmlrpc"

	any_flags=""
	use mysql && any_flags="mysql mysqli"

	if ! PHPCHECKNODIE="yes" require_php_with_use ${flags} \
		|| ! PHPCHECKNODIE="yes" require_php_with_any_use ${any_flags}; then
		die "Re-install ${PHP_PKG} with ${flags} and either ${any_flags}"
	fi
	if use vacation; then
		enewgroup vacation
		enewuser vacation -1 -1 -1 vacation
	fi
}

src_prepare() {
	use env_password && epatch "${FILESDIR}"/database-credentials-debian.patch

}
src_install() {
	webapp_src_preinst

	if use addition; then

		exeinto /usr/libexec/${PV}
		doexe "${S}"/ADDITIONS/*.pl
		doexe "${S}"/ADDITIONS/*.sh

		insinto /usr/libexec/${PV}
		doins "${S}"/ADDITIONS/change_password.tgz
		doins "${S}"/ADDITIONS/postfixadmin-0.3-1.4.tar.gz

		if use doc;then
			newdoc  "${S}"/ADDITIONS/README.TXT ADDITIONS_README.TXT
		fi
	fi

	if use doc; then

		dodoc  DOCUMENTS/*.txt
		dodoc INSTALL.TXT VIRTUAL_VACATION_INSTALL.TXT \
										VIRTUAL_VACATION/FILTER_README
	fi

	if use vacation; then
		diropts -m0770 -o vacation -g vacation
		dodir /var/spool/vacation
		keepdir /var/spool/vacation
		insinto /var/spool/vacation
		insopts -m770 -o vacation -g vacation
		doins "${S}"/VIRTUAL_VACATION/vacation.pl

		diropts -m775 -o root -g root
		insopts -m644 -o root -g root
	fi

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	for FILE in ${docs} GPL-LICENSE.TXT LICENSE.TXT  debian/ tests/ ADDITIONS/
	do
	  rm -rf ${FILE}
	done

	webapp_configfile "${MY_HTDOCSDIR}"/config.inc.php

	webapp_postinst_txt en "${FILESDIR}"/ postinstall-en-2.3.txt
	webapp_src_install
}
