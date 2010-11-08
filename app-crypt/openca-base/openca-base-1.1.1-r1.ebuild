# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="2.5"

inherit eutils multilib autotools

WEBAPP_MANUAL_SLOT="yes"
#WEBAPP_DEPEN="dev-lang/perl"
DESCRIPTION="Open Source out-of-the-box Certification Authority system"
HOMEPAGE="http://www.openca.org/"
SRC_URI="mirror://sourceforge/openca/${P}.tar.gz"

LICENSE="OpenCA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbm mysql +postgres ldap sasl install-offline install-online install-ext scep db2"

COMMON_DEP="!app-crypt/openca
	dev-libs/openssl
	www-servers/apache:2[ssl]
	ldap? (
		( || ( net-nds/openldap ) (  net-nds/389-ds-base ) )
		>=dev-perl/perl-ldap-0.28
		>=dev-perl/IO-Socket-SSL-0.92
		>=dev-perl/URI-1.23 )
	app-misc/openca-tools
	virtual/mta
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	dbm? ( perl-core/DB_File )
	sasl? ( dev-perl/Authen-SASL )
	>=dev-lang/perl-5.8
	dev-perl/Digest-HMAC
	virtual/perl-Digest-SHA
	virtual/perl-Digest-MD5
	dev-perl/libintl-perl
	dev-perl/IO-stringy
	dev-perl/MIME-Lite
	dev-perl/MIME-tools
	dev-perl/MailTools
	dev-perl/Parse-RecDescent
	dev-perl/X500-DN
	dev-perl/XML-Twig
	dev-perl/CGI-Session
	dev-perl/net-server
	dev-perl/Convert-ASN1
	dev-perl/Bit-Vector
	dev-perl/OpenCA-AC
	dev-perl/OpenCA-CRL
	dev-perl/OpenCA-CRR
	dev-perl/OpenCA-Configuration
	dev-perl/OpenCA-Crypto
	dev-perl/OpenCA-DB
	dev-perl/OpenCA-DBI
	dev-perl/OpenCA-Log
	dev-perl/OpenCA-LDAP
	dev-perl/OpenCA-OpenSSL
	dev-perl/OpenCA-PKCS7
	dev-perl/OpenCA-RBAC
	dev-perl/OpenCA-REQ
	dev-perl/OpenCA-Session
	dev-perl/OpenCA-StateMachine
	dev-perl/OpenCA-TRIStateCGI
	dev-perl/OpenCA-Tools
	dev-perl/OpenCA-UI-HTML
	dev-perl/OpenCA-X509
	dev-perl/OpenCA-XML-Cache"

DEPEND="${COMMON_DEP}
	sys-devel/libtool
	dev-util/pkgconfig"

RDEPEND="${COMMON_DEP}"

src_prepare() {
	epatch "${FILESDIR}"/gentoofu_configure.in.patch
	eaclocal
	eautoconf
}

src_configure() {
	einfo "Configuring ${P}"
	local docroot="/usr/share/openca-${PV}"

myconf=" \
		--with-openca-prefix=/usr \
		--with-openca-user=openca \
		--with-openca-group=openca \
		--with-htdocs-fs-prefix=$docroot/htdocs/openca \
		--with-cgi-fs-prefix=$docroot/cgi-bin \
		--with-etc-prefix=/etc/openca \
		--with-var-prefix=/var/lib/openca \
		--with-lib-prefix=/usr/$(get_libdir)/openca \
		--with-web-host=localhost \
		--with-httpd-user=apache \
		--with-httpd-group=apache \
		--enable-maintainer-mode \
		--disable-external-modules \
		--disable-package-build \
		--with-dist-user=portage \
		--with-dist-group=portage \
		--with-sendmail=/usr/bin/sendmail \
		--with-module-prefix=/usr/$(get_libdir) \
		--with-service-mail-account=openca@localhost \
		--with-cert-chars=UTF8 \
		--with-auth-user=admin \
		--with-auth-password=gentoo"

		if use mysql; then
			einfo "Setting random user/password details for the mysql database"
			local dbpass="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
			myconf="${myconf}  --with-db-type=mysql \
					--with-db-name=openca \
					--with-db-host=localhost \
					--with-db-port=3306 \
					--with-db-user=openca \
					--with-db-passwd='${dbpass}'"
		fi

		if use postgres; then
				einfo "Setting random user/password details for the postgres database"
				local dbpass="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
			myconf="${myconf}  --with-db-type=Pg \
					--with-db-name=openca \
					--with-db-host=localhost \
					--with-db-port=5432 \
					--with-db-user=openca \
					--with-db-passwd='${dbpass}'"
		fi

		use scep && myconf+=" --enable-scep "

		econf ${myconf} || die "econf failed"

#Disable Perl Module Build ; Use system module

	cp "${FILESDIR}"/Makefile.perl-disable-1.0.2 "${S}"/src/ext-modules/Makefile || die

	cp "${FILESDIR}"/Makefile.perl-disable-1.0.2 "${S}"/src/modules/Makefile || die
}

src_install () {

	if use install-offline;then
	make   DEST_DIR="${D}" install-offline ||die "install CA failed"
	fi

	if use install-online ;then
	DEST_DIR="${D}"  install-online ||die "install failed"
	fi

	if use install-ext;then
	make   DEST_DIR="${D}"  install-ext ||die "install failed"
	fi

	rm -fr "${D}"/usr/etc || die

	 newinitd ${FILESDIR}/openca.init openca
	 newconfd ${FILESDIR}/openca.conf openca
	if use ldap; then
		insinto  /etc/openldap/schema/
		doins contrib/openldap/openca.schema
	fi
	dodoc ChangeLog INSTALL I18N NOTES.Chain README STATUS THANKS
	dodoc docs/HISTORY 
	doman docs/man3/base.3

}

pkg_postinst() {
	einfo "Please check file '/etc/openca/config.xml'"
	einfo "Then run '/etc/openca/configure_etc.sh' script"
	einfo "If you use apache web server,"
	einfo " it's highly recommended to use SuExec feature"
	einfo "to work with different user permision"
}

pkg_setup() {
	enewgroup openca
	enewuser openca -1 -1 /dev/null openca
}

pkg_config() {
	/bin/sh $EDITOR /etc/openca/config.xml ; /etc/openca/configure_etc.sh
}
