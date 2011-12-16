# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit webapp  depend.php

DESCRIPTION="GLPI is the Information Resource-Manager with an additional Administration- Interface."
HOMEPAGE="http://www.glpi-project.org/"
SRC_URI="https://forge.indepnet.net/attachments/download/943/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

need_php5_httpd

DEPEND=""
RDEPEND="dev-lang/php[mysql]"

S="${WORKDIR}/${PN}"

pkg_pretend() {
	PHPCHECKNODIE="yes"	require_php_with_use mysql
}

pkg_setup() {
	require_php_with_use mysql
	webapp_pkg_setup
}

src_install() {

	webapp_src_preinst

	einfo "Installing files"
	insinto "${MY_HTDOCSDIR}"
	doins -r .
	doins .htaccess

	webapp_serverowned -R "${MY_HTDOCSDIR}"/{files,config}

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
