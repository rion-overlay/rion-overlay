# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PHPCHECKNODIE="yes"
inherit webapp eutils depend.apache depend.php confutils

DESCRIPTION="MailZu is a simple and intuitive web interface to manage Amavisd-new quarantine"
HOMEPAGE="http://sf.net/projects/mailzu/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/MailZu%200.8RC3/MailZu_0.8RC3.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="ldap mysql postgres db_clean"

DEPEND="mail-filter/amavisd-new[ldap?,mysql?,postgres?]"
RDEPEND="${DEPEND}
		dev-php/PEAR-PEAR
		dev-php/PEAR-DB
		dev-php/PEAR-Mail_Mime
		dev-php/PEAR-Net_Socket
		db_clean? ( dev-perl/DBI )
		dev-lang/php[sockets,ldap?,mysql?,postgres?]"
S="${WORKDIR}"/MailZu_0.8RC3

need_apache2_2
need_php5_httpd

pkg_setup() {
	confutils_require_any mysql postgres ldap

	local flags="sockets"

	use postgres	&& flags+=" postgres"
	use ldap		&&	flags+=" ldap"

	require_php_with_any_use ${flags} || die "Re-install ${PHP_PKG} with ${flags}"

	if use mysql;then
		( ( require_php_with_use mysql ) || ( require_php_with_use mysqli ) ) || die \
		"Re-install ${PHP_PKG} with mysql or mysli USE"
	fi
	webapp_pkg_setup
}

src_prepare() {
	sed -i -e "1s/usr\/local\/bin\/perl/usr\/bin\/perl/" scripts/mz_db_clean.pl \
																	|| die "sed failed"
	cp config/config.php.sample config/config.php
}

src_install() {
	dodoc CHANGELOG README docs/*
	rm "${S}"/{CHANGELOG,README,LICENSE}
	rm -rf "${S}"/docs

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .
	webapp_configfile	"${MY_HTDOCSDIR}"/config/config.php
	webapp_src_install
}
