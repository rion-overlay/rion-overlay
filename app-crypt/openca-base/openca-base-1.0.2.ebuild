# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils  webapp multilib

WEBAPP_MANUAL_SLOT="yes"
#WEBAPP_DEPEN="dev-lang/perl"
DESCRIPTION="Open Source out-of-the-box Certification Authority system"
HOMEPAGE="http://www.openca.org/"
SRC_URI="mirror://sourceforge/openca/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="OpenCA"
SLOT="0"
KEYWORDS="~x86"
IUSE="dbm mysql +postgres ldap vhosts sasl ca-only ra-only node-only scep
full-install db2"
DEPEND="
		!app-crypt/openca
		dev-libs/openssl
		www-servers/apache:2[ssl]
		ldap? ( net-nds/openldap
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
	 	dev-perl/Convert-ASN1"
#	 	virtual/perl-OpenCA "
RDEPEND="${DEPEND}"
src_configure() {
	einfo "Configuring ${P}"
myconf=" \
		--with-openca-user=openca \
		--with-openca-group=openca \
		--with-htdocs-fs-prefix=/var/www/localhost/htdocs/openca \
		--with-cgi-fs-prefix=/var/www/localhost/cgi-bin \
		--with-etc-prefix=/etc/openca \
		--with-var-prefix=/var/openca \
		--with-lib-prefix=/usr/$(get_libdir)/openca \
		--with-httpd-user=apache \
		--with-httpd-group=apache \
		--disable-external-modules \
		--with-external-modules \
		--disable-package-build \
		--with-dist-user=portage \
		--with-dist-group=portage \
		--with-sendmail=/usr/bin/sendmail \
		--with-module-prefix=/usr/$(get_libdir) \
		--with-service-mail-account=openca@localhost \
		--with-cert-chars=UTF8 \
		"
		if ! use vhosts ; then
			myconf="${myconf} --with-htdocs-url-prefix=/openca"
		fi
		if use ldap; then
			myconf="${myconf} --with-ldap-port=389 \
			--with-ldap-root='cn=Manager,o=Gentoo,c=ORG' \
			--with-ldap-root-pwd='openca' \
			"
		else
			myconf="${myconf} --disable-ldap"
		fi

		if ! use mysql && ! use postgres && ! use db2|| use dbm; then
			myconf="${myconf} --enable-db"
		else
		myconf="${myconf} --disable-db"
		fi
		if use mysql; then
			einfo "Setting random user/password details for the mysql database"
			local dbpass="${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
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
			myconf="${myconf}  \
					--enable-dbi \
					--with-db-type=Pg \
					--with-db-name=openca \
					--with-db-host=localhost \
					--with-db-port=5432 \
					--with-db-user=openca \
					--with-db-passwd='${dbpass}'"
		fi

	econf ${myconf} || die "econf failed"

# Set Gentoo dist.
	sed -i -e  's/Fedora/Gentoo/g' Makefile.global-vars || die

#Disable Perl Module Build ; Use system module

	cp "${FILESDIR}"/Makefile.perl-disable-1.0.2 "${S}"/src/ext-modules/Makefile || die

	cp "${FILESDIR}"/Makefile.perl-disable-1.0.2 "${S}"/src/modules/Makefile || die
}
src_compile(){
	einfo "Compiling ${P}"
	einfo "run emake  ext"
#  make  CA server related
# if use ca-onlu; then
#emake ca  ||die "emake ext failed"
# fi
#  RA and public server relate
# if use ra-onlu; then
#	emake ext || die
# fi
#emake doc 	|| die everything documentation related
# ALL make everything
	emake ||die
}

src_install () {
	webapp_src_preinst

# install CA script
	make   DEST_DIR="${D}" install-ca  ||die "install CA failed"
#install [install-node]    install aministration components
	make   DEST_DIR="${D}" install-node  ||die "install node failed"
#install-pub public server components
	make   DEST_DIR="${D}" install-pub ||die "install pub failed"
#install-ra RA server components
	make   DEST_DIR="${D}" install-ra  ||die "install failed"
#install-scep]    install scep server components
	make   DEST_DIR="${D}" install-scep  ||die "install failed"
#install-doc]     install documentation
# Not work , upstaream bug
# 	make   DEST_DIR="${D}" install-doc ||die "install failed"


	doman docs/man3/base.3
	dodoc CHANGES HISTORY I18N INSTALL README
	dodoc README RELEASE-NOTES STATUS THANKS
	dodoc VERSION
#	dodir "${MY_HOSTROOTDIR}"/${PF}
	mv "${D}"/var/www/localhost/htdocs/openca/* "${D}/${MY_HTDOCSDIR}" || die
	mv "${D}"/var/www/localhost/cgi-bin/* "${D}/${MY_CGIBINDIR}" || die
	rm -fr "${D}"/var/www/ || die
	webapp_src_install

# install ldap schema
	if use ldap ; then
		dodir /etc/openldap/schema/
		cp "${FILESDIR}"/openca.schema "${D}"/etc/openldap/schema/ || die
	fi
# install init.d script
	cp -f "${FILESDIR}"/openca "${D}"/etc/init.d/ || die
# keeping directory
	cd "${D}"/var/openca
	for i in bp crypto db log mail session tmp bp/dataexchange bp/users \
			bp/dataexchange/pkcs12 bp/users crypto/cacerts crypto/bcerts \
			crypto/chain crypto/certs crypto/chain crypto/crls crypto/keys \
			crypto/reqs/ ;
	do
		keepdir /var/openca/$i||die
	done
	webapp_postinst_txt ru "${FILESDIR}"/postinstall.ru
}

pkg_postinst() {
	einfo "Please check file '/etc/openca/config.xml'"
	einfo "Then run '/etc/openca/configure_etc.sh' script"
}
pkg_config() {
	einfo "Please check file '/etc/openca/config.xml'"
	/etc/openca/configure_etc.sh --help
}
pkg_setup() {
	enewgroup openca
	enewuser openca -1 -1 /dev/null openca
	webapp_pkg_setup
}
pkg_config() {
	/bin/sh $EDITOR /etc/openca/config.xml ; /etc/openca/configure_etc.sh
}
