# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/policyd/policyd-1.82-r1.ebuild,v 1.4 2011/12/14 20:33:46 ago Exp $


EAPI=4

MY_PN="cluebringer"

inherit multilib

DESCRIPTION="Policy daemon for postfix and other MTAs"
HOMEPAGE="http://policyd.sf.net/"
SRC_URI="http://download.policyd.org/v2.0.14/cluebringer-v2.0.14.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite +webinterface"

DEPEND="dev-perl/net-server
	dev-perl/Net-CIDR
	dev-perl/Config-IniFiles
	dev-perl/Cache-FastMmap
	dev-perl/Mail-SPF
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	sqlite? ( dev-db/sqlite )
	webinterface? ( dev-lang/php[pdo]
					virtual/httpd-php )
	"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

isrc_prepare() {
	sed -e # add usel ib location
}

src_install() {
	insinto /usr/$(get_libdir)/policyd-2.0
	#insopts -o root -g nobody -m 0750
	doins -r cbp/*
	
	insinto /etc/
	nonfatal doins cluebringer.conf

	dobin cbpadmin
	dobin cbpolicyd

	dodoc ChangeLog WISHLIST UPGRADING TODO INSTALL

	newinitd "${FILESDIR}/${PN}.rc" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	insinto "/usr/share/${P}/databases"
	doins  -r database/*

	if use webinterface; then
		insinto "/usr/share/${P}/web"
		doins -r webui/*
	fi
}

pkg_postinst() {
	elog "You will need to create the database using the script DATABASE.mysql"
	elog "in /usr/share/databeses/${PF}/"
	elog "Read the mysql section of the README.txt for details."
	elog
	elog "To use policyd with postfix, update your /etc/postfix/main.cf file by adding"
	elog "  check_policy_service inet:127.0.0.1:10031"
	elog "to your smtpd_recipient_restrictions line, or similar."
	elog
	elog "Also remember to start the daemon at boot:"
	elog "  rc-update add policyd default"
	elog
	elog "Read the documentation for more info."
}
