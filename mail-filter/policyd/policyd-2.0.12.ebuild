# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_PN="cluebringer"

inherit multilib

DESCRIPTION="Policy daemon for postfix and other MTAs"
HOMEPAGE="http://policyd.sf.net/"
SRC_URI="http://devlabs.linuxassist.net/attachments/download/223/${MY_PN}-2.0.12.tar.xz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="mysql postgres sqlite3 webinterface"

DEPEND="
	dev-perl/net-server
	dev-perl/Net-CIDR
	dev-perl/Config-IniFiles
	dev-perl/Cache-FastMmap
	dev-perl/Mail-SPF
	dev-perl/DBI
	mysql? ( virtual/mysql
			dev-perl/DBD-mysql )
	postgres? ( dev-db/postgresql-base
			dev-perl/DBD-Pg )
	sqlite3? ( dev-db/sqlite:3
			dev-perl/DBD-SQLite )
	webinterface? ( dev-lang/php[pdo,mysql?,postgres?,sqlite3?]
					virtual/httpd-php )
	"

RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( mysql postgres sqlite3 )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {

	for i in cbpadmin cbpolicyd ; do
		sed  -e \
		's#use lib('/usr/local/lib/policyd-2\.0','/usr/lib/policyd-2\.0'#&,'/usr/lib64/policyd-2\.0'#' \
		-i ${i}|| die "sed failed"
	done

	cd "${S}"/database

}

src_install() {
	insinto /etc/
	doins cluebringer.conf

	dosbin cbpadmin
	dosbin cbpolicyd

	dodoc ChangeLog WISHLIST UPGRADING TODO INSTALL
	dodoc -r contrib

	newinitd "${FILESDIR}/${PN}.rc" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	insinto "/usr/share/${P}/databases"
	doins  -r database/*
	exeinto "/usr/share/${P}/databases"
	doexe database/convert-tsql

	if use webinterface; then
		insinto "/usr/share/${P}/web"
		doins -r webui/*
	fi

	insinto /usr/$(get_libdir)/policyd-2.0/cbp
	insopts -o root -g nobody -m 0750
	doins -r cbp/*

	docompress -x /usr/share/doc/${P}/contrib

}

pkg_postinst() {

	elog "You will need to create the database using the scrit convert-tsql"
	elog "in /usr/share/${P}/databases"
	elog "Read the database section of the INSTALL for details."
	elog "Web interface file installed to /usr/share/${P}/web/"
	elog "You can setup you web server to execute script in this directory"
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

#ipkg_config() {
#for db_type in mysql pgsql sqlite; do
#./convert-tsql ${db_type} core.tsql > policyd.${db_type}.sql
#for file in `find . -name \*.tsql -and -not -name core.tsql`; do
#./convert-tsql ${db_type} ${file}
#        done >> policyd.${db_type}.sql
#        cd whitelists
#            ./parse-checkhelo-whitelist >> policyd.${db_type}.sql
#            ./parse-greylisting-whitelist >> policyd.${db_type}.sql
#        done
#}
