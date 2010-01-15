# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: net-im/gluxi/gluxi-9999.ebuild,v 1.4 2008/07/14 20:47:04 AntiXpucT Exp $
# TODO: Дописать (post)install под postgresql
inherit cmake-utils eutils mercurial

DESCRIPTION="Powerfull Jabber-bot based on net-libs/gloox"
HOMEPAGE="http://gluxi.inhex.net/"
EHG_REPO_URI="http://hg.inhex.net/gluxi-dev"
LICENSE="GPL-2 LGPL"
SLOT="0"
KEYWORDS="~x86 ~adm64"
IUSE="mysql postgresql"
RDEPEND="<net-libs/gloox-1.0
dev-libs/openssl
mysql? ( virtual/mysql )
postgres? ( virtual/postgresql-server )
www-client/lynx
x11-libs/qt-core
"
DEPEND="${RDEPEND}
dev-util/cmake
sys-devel/gcc
sys-devel/make
"
S="${WORKDIR}"/gluxi-dev
pkg_setup() {
	enewuser gluxi -1 -1 /var/log/gluxi nobody;
}

src_install() {
	dodir /var/log/gluxi
	exeinto /usr/bin;
	doexe "${S}"_build/gluxi
	insinto /etc/gluxi
	doins "${FILESDIR}"/gluxi.cfg
	insinto /usr/share/gluxi
	use mysql && doins "${FILESDIR}"/mysql_inst.sql
	use postgresql && doins -r sql
	use postgresql && fperms +x /usr/share/gluxi/update/dbupdate.sh
	newinitd "${FILESDIR}/gluxi.init" gluxi
}

pkg_postinst() {
	ewarn "If it is first your install of gluxi on this machine, then you should do next steps before gluxi will working:"
	einfo "type these commands in command line:"
	use mysql && einfo "echo \"create database gluxi;\\\ngrant all privileges on gluxi.* to gluxi@localhost identified by 'gluxi' with grant option;\\\n\" | mysql -u root"
	use mysql && einfo "mysql -ugluxi -pgluxi -G gluxi < /usr/share/gluxi/mysql_inst.sql"
	ewarn "And, finaly, edit /etc/gluxi/gluxi.cfg for your own settings."
}
