# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit depend.php webapp

DESCRIPTION="Unclassified NewsBoard (short UNB) is internet bulletin board system"
HOMEPAGE="http://newsboard.unclassified.de"
SRC_URI="http://newsboard.unclassified.de/download/unb/devel/20090606 -> unb.devel.20090606.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/zip"
RDEPEND=""

need_php5

S="${WORKDIR}/${PN}"

src_install() {
	webapp_src_preinst
	cd "${S}"
	cp board.conf.php.example board.conf.php
	cp -R . "${D}"/"${MY_HTDOCSDIR}"

	for foo in extra unb_lib ; do
		webapp_serverowned -R "${MY_HTDOCSDIR}"/"${foo}"  || die
	done
	webapp_serverowned "${MY_HTDOCSDIR}"/forum.php
	webapp_serverowned "${MY_HTDOCSDIR}"/install.php
	webapp_configfile "${MY_HTDOCSDIR}"/.htaccess
	webapp_configfile "${MY_HTDOCSDIR}"/board.conf.php

	webapp_src_install
}
