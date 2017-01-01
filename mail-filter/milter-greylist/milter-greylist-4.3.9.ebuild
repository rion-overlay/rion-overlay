# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit base eutils user flag-o-matic autotools

DESCRIPTION="Milter-greylist is a stand-alone milter that implements the greylist filtering method"
HOMEPAGE="http://hcpnet.free.fr/milter-greylist"
SRC_URI="ftp://ftp.espci.fr/pub/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 bind ldap geoip spf p0f spamassassin sendmail postfix curl"

CDEPEND="
	dev-libs/openssl
	net-mail/mailbase
	sendmail? ( !!mail-filter/libmilter )
	<sys-libs/db-5.0.0
	p0f? ( net-analyzer/p0f )
	bind? ( net-dns/bind[ipv6?] )
	ldap? ( net-nds/openldap[ipv6?] )
	curl? ( net-misc/curl[ipv6?] )
	geoip? ( dev-libs/geoip )
	spf? ( mail-filter/libspf2 )
	postfix? ( mail-filter/libmilter[ipv6?] )
	spamassassin? ( mail-filter/spamassassin )
	"
#	drac-p? ( mail-client/drac )
DEPEND="sys-devel/flex
	sys-devel/bison
	virtual/pkgconfig
	${CDEPEND}
	"

RDEPEND="${CDEPEND}"

PATCHES=("${FILESDIR}"/*.patch)

REQUIRED_USE="|| (
			sendmail? ( || ( !postfix ) ( sendmail ) )
			postfix?  ( || ( !sendmail ) ( postfix ) )
				)
				( ^^ ( postfix sendmail ) )
				"

pkg_setup() {
		enewgroup milter
		enewuser milter  -1 -1 /var/lib/milter milter

}

src_prepare() {
	sed  -e "/CONFFILE/s/greylist.conf/greylist2.conf/" -i Makefile.in

	sed -i -e 's/#nodrac/nodrac/' greylist2.conf

sed -e 's|"/var/milter-greylist/milter-greylist.sock"|"/var/run/milter-greylist/milter-greylist.sock"|'\
		-i greylist2.conf

sed -e 's|"/var/milter-greylist/milter-greylist.sock"|"/var/run/milter-greylist/milter-greylist.sock"|'\
	-i milter-greylist.m4

sed -e 's|"/var/milter-greylist/greylist.db"|"/var/lib/db/milter-greylist/greylist.db"|'\
					-i greylist2.conf

	ecvs_clean
	base_src_prepare
	eautoconf
}

src_configure() {
	local myconf=""

		myconf+="--with-user=milter "

	use bind	&& myconf+=" --with-libbind"
	use spf		&& myconf+=" --with-libspf2"
	use geoip	&& myconf+=" --with-libGeoIP"
	use ldap	&& myconf+=" --with-openldap"
	use curl	&& myconf+=" --with-libcurl"

	econf \
		--with-db \
		--enable-mx \
		--disable-rpath \
		--with-libmilter \
		--with-openssl \
		--with-conffile="/etc/mail/${PN}.conf" \
		--with-dumpfile="/var/lib/${PN}/${PN}.db" \
		--with-thread-safe-resolver \
		$(use_enable p0f) \
		$(use_enable spamassassin) \
		--enable-dnsrbl \
		$(use_enable postfix) \
		${myconf}

}

src_compile() {
	append-cflags -no-strict-aliasing -no-unused-function
	emake -j1
}

src_install() {

	emake DESTDIR="${ED}" install

	if use !postfix;then
		insinto /usr/share/sendmail-cf/hack/
		doins milter-greylist.m4
	fi

	dodoc ChangeLog README milter-greylist.m4

	newinitd "${FILESDIR}"/gentoo.initd milter-greylist
	newconfd  "${FILESDIR}"/gentoo.confd milter-greylist

	diropts -m750 --owner=milter
	dodir /var/run/milter-greylist/

	diropts -m770 --owner=milter
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
