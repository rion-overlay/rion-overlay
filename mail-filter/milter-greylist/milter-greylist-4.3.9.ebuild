# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit base eutils user

DESCRIPTION="Milter-greylist is a stand-alone milter that implements the greylist filtering method"
HOMEPAGE="http://hcpnet.free.fr/milter-greylist"
SRC_URI="ftp://ftp.espci.fr/pub/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 bind +ssl ldap geoip spf dkim drac-p +p0f spamassassin sendmail dnsrbl postfix curl"

CDEPEND="net-mail/mailbase
	sendmail? (
		mail-mta/sendmail
		!!mail-filter/libmilter
		dkim? (
			mail-filter/libdkim
			)
			)
	<sys-libs/db-5.0.0
	p0f? ( net-analyzer/p0f )
	bind? ( net-dns/bind[ipv6?] )
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap[ipv6?] )
	curl? ( net-misc/curl[ipv6?] )
	geoip? ( dev-libs/geoip )
	spf? ( mail-filter/libspf2 )
	postfix? (
				>=mail-mta/postfix-2.5
				mail-filter/libmilter[ipv6?]
				)
	drac-p? ( mail-client/drac )
	spamassassin? ( mail-filter/spamassassin[ipv6,ldap?] )
	"
DEPEND="sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
	${CDEPEND}
	"

RDEPEND="${CDEPEND}"

REQUIRED_USE="|| (
			sendmail? ( || ( !postfix ) ( sendmail ) )
			postfix?  ( || ( !sendmail ) ( postfix ) )
				)
				( ^^ ( postfix sendmail ) )"

pkg_setup() {
	if use postfix ;then
		einfo "Checking for postfix group ..."
		enewgroup postfix 207

		einfo "Checking for postdrop group ..."
		enewgroup postdrop 208

		einfo "Checking for postfix user ..."
		enewuser postfix 207 -1 /var/spool/postfix postfix,mail
	else

		einfo "checking for smmsp group...    create if missing."
		enewgroup smmsp 209

		einfo "checking for smmsp user...     create if missing."
		enewuser smmsp 209 -1 /var/spool/mqueue smmsp
	fi

}

src_prepare() {
	sed  -e "/CONFFILE/s/greylist.conf/greylist2.conf/" -i Makefile.in

	if use drac; then
	sed -i -e  \
			's|"/usr/local/etc/drac.db/"|"/var/lib/drac/drac.db"|' greylist2.conf
	else
		sed -i -e 's/#nodrac/nodrac/' greylist2.conf
	fi

#	if use postfix; then
#		sed -e 's/#user\ "smmsp"/user\ "milter"/' -i greylist2.conf \							
#	fi

sed -e 's|"/var/milter-greylist/milter-greylist.sock"|"/var/run/milter-greylist/milter-greylist.sock"|'\
		-i greylist2.conf

sed -e 's|"/var/milter-greylist/milter-greylist.sock"|"/var/run/milter-greylist/milter-greylist.sock"|'\
	-i milter-greylist.m4

sed -e 's|"/var/milter-greylist/greylist.db"|"/var/lib/db/milter-greylist/greylist.db"|'\
					-i greylist2.conf

	ecvs_clean
}

src_configure() {
	local myconf=""

#	if use postfix ;then
#		myconf+="--with-user=postfix "
#	else
#		myconf+="--with-user=smmsp "
#	fi
	use bind	&& myconf+=" --with-libbind"
	use spf		&& myconf+=" --with-libspf2"
	use dkim	&& myconf+=" --with-libdkim=/usr/lib64/"
	use geoip	&& myconf+=" --with-libGeoIP"
	use ssl		&& myconf+=" --with-openssl"
	use ldap	&& myconf+=" --with-openldap"
	use curl	&& myconf+=" --with-libcurl"

	econf \
		--with-db \
		--enable-mx \
		--disable-rpath \
		--with-libmilter \
		--with-conffile="/etc/mail/${PN}.conf" \
		--with-dumpfile="/var/lib/${PN}/${PN}.db" \
		--with-thread-safe-resolver \
		$(use_enable drac-p drac) \
		$(use_enable p0f) \
		$(use_enable spamassassin) \
		$(use_enable dnsrbl) \
		$(use_enable postfix) \
		${myconf}
}

src_install() {

	emake DESTDIR="${ED}" install || die "install failed"

	if use !postfix;then
		insinto /usr/share/sendmail-cf/hack/
		doins milter-greylist.m4
	fi

	dodoc ChangeLog README milter-greylist.m4

	newinitd "${FILESDIR}"/gentoo.initd milter-greylist
	newconfd  "${FILESDIR}"/gentoo.confd milter-greylist

	if use postfix;then
		echo "USER=postfix" >> "${ED}"/etc/conf.d/milter-greylist || die
	else
		echo "USER=smmsp" >> "${ED}"/etc/conf.d/milter-greylist || die
	fi

	local user="smmsp"
	use postfix && user="postfix"

	diropts -m750 --owner=$user
	dodir /var/run/milter-greylist/

	diropts -m770 --owner=$user
	dodir /var/lib/milter-greylist/
	keepdir /var/lib/milter-greylist/
}

pkg_postinst() {
	if [  -e "${EROOT}"/var/lib/milter-greylist/greylist.db ] ; then
		touch "${EROOT}"/var/lib/milter-greylist/greylist.db
	fi

	if use !postfix; then
		elog
		elog " You can enable milter-greylist in your sendmail, adding the line: "
		elog " HACK(\`milter-greylist')dnl"
		elog " to you sendmail.mc file"
		elog
	fi

	if use postfix;then
		chown postfix "${ROOT}"/var/lib/milter-greylist/greylist.db

		elog
		elog " You can enable milter-greylist in your postfix, adding the line:"
		elog " smtpd_milters = unix:/var/run/milter-greylist/milter-greylist.sock "
		elog " milter_connect_macros = j "
		elog " and "
		elog " milter_default_action = accept "
		elog " to /etc/postfix/main.cf file"
		elog
	fi

	elog "Config  files for milter-greylist /etc/milter-greylist/milter-greylist.conf"
	elog "Please edit it - default config not works and bad."
	elog "For more info see http://milter-greylist.wikidot.com/"
}
