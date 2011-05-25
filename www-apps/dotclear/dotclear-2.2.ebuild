# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PHPCHECKNODIE="yes"
inherit webapp depend.php confutils

DESCRIPTION="Weblogs management tool written in PHP"
HOMEPAGE="http://www.dotclear.net"
SRC_URI="http://download.dotclear.org/latest/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="postgres mysql sqlite gd"

DEPEND="dev-lang/php:5[iconv,simplexml,xml,unicode,postgres?,mysql?,sqlite?,gd?]"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

need_php5_httpd

# Lang Files http://download.dotclear.org/l10n/2.1.6

pkg_setup() {

	confutils_require_any postgres mysql sqlite

	local flags="iconv simplexml unicode"
	use mysql 		&& flags+=" mysql"
	use postgres	&& flags+=" postgres"
	use sqlite		&& flags+=" sqlite"

	require_php_with_use "${flags}" || die "Re-install ${PHP_PKG} with ${flags}"

	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	for foo in cache public;
		do
			webapp_serverowned -R "${MY_HTDOCSDIR}/${foo}"  || die
			chmod 666 "${D}/${MY_HTDOCSDIR}/${foo}"
		done
	for foo in cache db inc plugins;
		do
			webapp_configfile "${MY_HTDOCSDIR}/${foo}"/.htaccess
		done
#		webapp_configfile "${MY_HTDOCSDIR}"/cache/.htaccess
#webapp_configfile "${MY_HTDOCSDIR}"/db/.htaccess
#		webapp_configfile "${MY_HTDOCSDIR}"/inc/.htaccess
#		webapp_configfile "${MY_HTDOCSDIR}"/plugins/.htaccess
#		webapp_configfile "${MY_HTDOCSDIR}"/

	webapp_postinst_txt en "${FILESDIR}"/postinst.en.txt
	webapp_src_install
}
