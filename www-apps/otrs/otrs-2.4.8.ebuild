# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit webapp eutils confutils

DESCRIPTION="OTRS is an Open source Ticket Request System"
HOMEPAGE="http://otrs.org/"
SRC_URI="ftp://ftp.otrs.org/pub/${PN}/${P}.tar.bz2"

LICENSE="AGPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="apache2 +mysql postgres mod_perl fastcgi ldap gd cjk +rpc"

# add oracle/mssql/DB2 DB support 
DEPEND="virtual/perl-Getopt-Long"
RDEPEND="${DEPEND}
	virtual/mta
	>=dev-lang/perl-5.8.8
	dev-perl/Authen-SASL
	dev-perl/Crypt-PasswdMD5
	dev-perl/DBI
	dev-perl/Date-Pcalc
	dev-perl/IO-stringy
	dev-perl/MIME-tools
	dev-perl/MailTools
	dev-perl/Net-DNS
	dev-perl/Mail-POP3Client
	dev-perl/TimeDate
	dev-perl/XML-Parser
	dev-perl/libwww-perl
	dev-perl/LWP-UserAgent-Determined
	dev-perl/PDF-API2
	dev-perl/IO-Socket-SSL
	dev-perl/Net-SMTP-SSL
	>=virtual/perl-CGI-3.33
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
	virtual/perl-libnet
	apache2? ( www-servers/apache:2
		mod_perl? ( =www-apache/libapreq2-2* www-apache/mod_perl )
			fastcgi? ( || ( www-apache/mod_fcgid www-apache/mod_fastcgi ) ) )
	fastcgi? ( dev-perl/FCGI )
	gd? ( dev-perl/GD dev-perl/GDTextUtil dev-perl/GDGraph )
	ldap? ( dev-perl/perl-ldap  )
	mysql? ( >=dev-perl/DBD-mysql-3.0005 )
	postgres? ( dev-perl/DBD-Pg )
	cjk? ( dev-perl/Encode-HanExtra )
	rpc? ( dev-perl/SOAP-Lite )"

pkg_setup() {

	webapp_pkg_setup

	if use apache2; then
		enewuser otrs -1 -1 /dev/null apache
	fi

	confutils_require_any postgres mysql
	confutils_use_depend_all mod_perl apache2
}

src_prepare() {
	cp Kernel/Config.pm{.dist,} || die

	cd ./Kernel/Config/ || die
	for i in *.dist; do
		cp ${i} $(basename ${i} .dist) || die
	done

	rm -fr "${S}/scripts"/{auto_*, redhat*, suse*, *.spec} || die

	if use fastcgi; then
		cd "${S}" || die
		epatch "${FILESDIR}"/apache2-2.patch
		sed -e "s|cgi-bin|fcgi-bin|" \
						-i scripts/apache2-httpd.include.conf || die
	fi
}

src_install() {
	webapp_src_preinst
	dodir "${MY_HOSTROOTDIR}/${PF}"

	dodoc CHANGES CREDITS README* TODO UPGRADING doc/otrs-database.dia \
			doc/test-* doc/X-OTRS-Headers.txt .fetchmailrc.dist \
			.mailfilter.dist .procmailrc.dist || die

	insinto "${MY_HOSTROOTDIR}/${PF}"
	doins -r .fetchmailrc.dist .mailfilter.dist .procmailrc.dist RELEASE \
			Kernel bin scripts var || die "doins failed"

	dodoc doc/manual/{en,de}/*.pdf

	mv "${D}/${MY_HOSTROOTDIR}/${PF}/var/httpd/"htdocs/* \
								"${D}/${MY_HTDOCSDIR}" || die "mv failed"
	rm -rf "${D}/${MY_HOSTROOTDIR}/${PF}"/var/httpd || die

	local a d="article log pics pics/images pics/stats sessions spool tmp"

	for a in ${d}; do
		keepdir "${MY_HOSTROOTDIR}/${PF}/var/${a}"
	done

	webapp_configfile "${MY_HOSTROOTDIR}"/${PF}/Kernel/Config.pm
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-2.txt
	webapp_postinst_txt ru "${FILESDIR}"/postinstall-ru-2.txt

	webapp_hook_script "${FILESDIR}"/reconfig-3
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
	webapp_pkg_postinst
}
