# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# revrite slepnoga

EAPI=2

inherit eutils	multilib
MY_P=${P/_/-}

DESCRIPTION="OpenCA main server"
HOMEPAGE="http://www.openca.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +dbm mysql +postgres ldap vhosts"

OPENCA_INT_MOD="dev-perl/OpenCA-Configuration
				dev-perl/OpenCA-DB
				dev-perl/OpenCA-LDAP
				<dev-perl/OpenCA-OpenSSL-1.0
				dev-perl/OpenCA-Session
				dev-perl/OpenCA-Tools
				dev-perl/OpenCA-UI-HTML
				dev-perl/OpenCA-XML-Cache
				dev-perl/OpenCA-AC
				dev-perl/OpenCA-CRL
				dev-perl/OpenCA-Crypto
				dev-perl/OpenCA-DBI
				dev-perl/OpenCA-Log
				dev-perl/OpenCA-PKCS7
				dev-perl/OpenCA-REQ
				dev-perl/OpenCA-StateMachine
				dev-perl/OpenCA-TRIStateCGI
				dev-perl/OpenCA-X509"

DEPEND="${RDEPEND}
		${OPENCA_INT_MOD}
	>=dev-libs/openssl-0.9.7
	www-servers/apache:2[ssl]
	dev-perl/XML-Parser
	virtual/perl-Digest-SHA
	virtual/perl-MIME-Base64
	virtual/perl-Digest-MD5
	dev-perl/net-server
	>=dev-perl/Digest-HMAC-1.01
	>=dev-perl/libintl-perl-1.10
	>=dev-perl/IO-stringy-2.108
	>=dev-perl/MIME-Lite-3.01
	>=dev-perl/MIME-tools-5.411
	>=dev-perl/MailTools-1.58
	>=dev-perl/Parse-RecDescent-1.94
	>=dev-perl/X500-DN-0.28
	>=dev-perl/XML-Twig-3.09
	>=dev-perl/CGI-Session-3.95
	>=dev-perl/net-server-0.86
	>=dev-perl/Convert-ASN1-0.18
	dbm? ( perl-core/DB_File )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	!mysql? ( !postgres? ( perl-core/DB_File ) )
	ldap? ( net-nds/openldap
		>=dev-perl/perl-ldap-0.28
		>=dev-perl/IO-Socket-SSL-0.92
		>=dev-perl/URI-1.23
		)
	sasl? ( >=dev-perl/Authen-SASL-2.04 )
	!=app-crypt/openca-base-1*
	!app-misc/openca-tools"

RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}

src_configure() {
	if ! use ldap ; then
		epatch "${FILESDIR}"/openca-0.9.2_noldap.patch
	fi

	myconf="--with-openca-user=openca \
		--with-openca-group=openca \
		--with-htdocs-fs-prefix=/var/www/localhost/htdocs/openca \
		--with-cgi-fs-prefix=/var/www/localhost/cgi-bin \
		--with-etc-prefix=/etc/openca \
		--with-var-prefix=/var/openca \
		--with-lib-prefix=/usr/lib/openca \
		--with-httpd-user=apache \
		--with-httpd-group=apache \
		--disable-external-modules"
#	if ! use vhosts ; then
		myconf="${myconf} --with-htdocs-url-prefix=/openca"
#	fi
	if use ldap; then
		myconf="${myconf} --with-ldap-port=389 \
			--with-ldap-root='cn=Manager,o=OpenCA,c=IT' \
			--with-ldap-root-pwd='openca'"
	else
		myconf="${myconf} --disable-ldap"
	fi
	if ! use mysql && ! use postgres || use dbm; then
		myconf="${myconf} --enable-db"
	else
		myconf="${myconf} --disable-db"
	fi
	if use mysql; then
			einfo "Setting random user/password details for the mysql database"
			local dbpass="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
			sed -e "s/@dbpass@/${dbpass}/g" \
						"${FILESDIR}"/mysql-setup.sql.in > "${T}"/mysql-setup.sql

		myconf="${myconf}  --enable-dbi \
			--with-db-type=mysql \
			--with-db-name=openca \
			--with-db-host=localhost \
			--with-db-port=3306 \
			--with-db-user=openca \
			--with-db-passwd='${dbpass}'"
	fi
	if use postgres; then
			einfo "Setting random user/password details for the postgres database"
			local dbpass="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"

		myconf="${myconf}  --enable-dbi \
			--with-db-type=Pg \
			--with-db-name=openca \
			--with-db-host=localhost \
			--with-db-port=5432 \
			--with-db-user=openca \
			--with-db-passwd='${dbpass}'"
	fi

cp "${FILESDIR}"/Makefile.perl-disable-0.9.3 "${S}"/src/ext-modules/Makefile || die

cp "${FILESDIR}"/Makefile.perl-disable-0.9.3 "${S}"/src/modules/Makefile || die

	econf ${myconf}
}

src_install() {
	emake -j1 DESTDIR="${D}" install-online install-ca || die "install failed"

	dodir /var/openca/tmp
	keepdir /var/openca/tmp
	fperms 775 /var/openca/tmp
	dosym /var/openca/log /var/log/openca
	dosym /etc/openca/utf8_latin1_selector.sh.template \
				/etc/openca/utf8_latin1_selector.sh

	keepdir /var/openca/log
	dodir /var/openca/log/xml
	keepdir /var/openca/log/xml

	dodoc CHANGES  README I18N HISTORY
	dodoc THANKS TODO
	doman docs/man3/*.3

	if use ldap; then
		docinto openldap
		dodocs contrib/openldap/openca.schema
	fi

	if ! use mysql && ! use postgres || use dbm ; then
		dodir /var/openca/db
		keepdir /var/openca/db
	fi

	if use vhosts; then
		insinto /etc/apache2/conf/vhosts
		#***more to come***
	fi
	dosym /etc/openca/openca_rc /etc/init.d/openca
	dodoc "${S}"/contrib/apache/httpd.conf.example
	dodoc "${S}"/contrib/apache/offline.conf
	dodoc "${S}"/contrib/openldap/*

}

pkg_setup() {
	enewgroup openca
	enewuser openca -1 -1 /dev/null openca
}

pkg_postinst() {
	einfo "Please check file '/etc/openca/config.xml'"
	einfo "Then run '/etc/openca/configure_etc.sh' script"
}
