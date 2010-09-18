# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit webapp eutils depend.apache

DESCRIPTION="OTRS is an Open source Ticket Request System"
HOMEPAGE="http://otrs.org/"
SRC_URI="ftp://ftp.otrs.org/pub/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="mysql postgres fastcgi ldap gd pdf"

RDEPEND="${DEPEND}
	virtual/mta
	=dev-lang/perl-5*
	dev-perl/Authen-SASL
	dev-perl/Crypt-PasswdMD5
	dev-perl/DBI
	dev-perl/Date-Pcalc
	dev-perl/IO-stringy
	dev-perl/MIME-tools
	dev-perl/MailTools
	dev-perl/Net-DNS
	dev-perl/TimeDate
	dev-perl/XML-Parser
	dev-perl/libwww-perl
	virtual/perl-CGI
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	virtual/perl-libnet
	apache2? ( =www-apache/libapreq2-2* )
	fastcgi? ( dev-perl/FCGI )
	gd? ( dev-perl/GD dev-perl/GDTextUtil dev-perl/GDGraph )
	ldap? ( dev-perl/perl-ldap )
	mysql? ( >=dev-perl/DBD-mysql-3.0005 )
	pdf? ( dev-perl/PDF-API2 )
	postgres? ( dev-perl/DBD-Pg )
"

want_apache

pkg_setup() {
	depend.apache_pkg_setup
	webapp_pkg_setup
	if use apache2; then
		enewuser otrs -1 -1 /dev/null apache
	fi
}

src_unpack() {
	unpack ${A}
	cp "${S}"/Kernel/Config.pm{.dist,}

	cd "${S}"/Kernel/Config/
	for i in *.dist; do
		cp ${i} $(basename ${i} .dist)
	done

	cd "${S}"/scripts
	rm -rf auto_* redhat* suse*

	if use fastcgi; then
		epatch "${FILESDIR}"/apache2.patch
		sed -e "s|cgi-bin|fcgi-bin|" -i "${S}"/scripts/apache2-httpd.include.conf
		sed -e "s|index.pl|index.fpl|" -i "${S}"/var/httpd/htdocs/index.html
	fi
}

src_install() {
	webapp_src_preinst
	dodir "${MY_HOSTROOTDIR}"/${PF}

	dodoc CHANGES CREDITS INSTALL README* TODO UPGRADING \
		doc/otrs-database.dia doc/test-* doc/X-OTRS-Headers.txt \
		.fetchmailrc.dist .mailfilter.dist .procmailrc.dist
	dodoc doc/manual/{en,de}/*.pdf

	insinto "${MY_HOSTROOTDIR}"/${PF}
	doins -r .fetchmailrc.dist .mailfilter.dist .procmailrc.dist RELEASE Kernel bin scripts var

	mv "${D}/${MY_HOSTROOTDIR}"/${PF}/var/httpd/htdocs/* "${D}/${MY_HTDOCSDIR}"
	rm -rf "${D}/${MY_HOSTROOTDIR}"/${PF}/var/httpd

	local a d="article log pics/images pics/stats pics sessions spool tmp"
	for a in ${d}; do
		keepdir "${MY_HOSTROOTDIR}"/${PF}/var/${a}
	done

	webapp_configfile "${MY_HOSTROOTDIR}"/${PF}/Kernel/Config.pm
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-2.txt
	webapp_hook_script "${FILESDIR}"/reconfig-4
	webapp_src_install
}

pkg_postinst() {
	ewarn "webapp-config will not be run automatically"
	ewarn "That messes up Apache configs"
	ewarn "Don't run webapp-config with -d otrs. Instead, try"
	ewarn "webapp-config -I -h <host> -d ot ${PN} ${PVR}"
	ewarn
	if ! use apache2; then
		ewarn "You did not activate the USE-flag apache2 which means you"
		ewarn "will need to create the otrs user yourself. Make this user"
		ewarn "a member of your webserver group."
	fi
	# webapp_pkg_postinst
}
