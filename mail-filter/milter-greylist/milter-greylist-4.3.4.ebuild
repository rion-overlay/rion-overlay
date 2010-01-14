# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base  eutils

DESCRIPTION="Milter-greylist is a stand-alone milter that implements the greylist filtering method"
HOMEPAGE="http://hcpnet.free.fr/milter-greylist"
SRC_URI="ftp://ftp.espci.fr/pub/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 bind ssl ldap geoip spf dkim drac p0f spamassassin dnsrbl postfix curl hardened"

COMMON_DEP="|| ( ( mail-filter/libmilter[ipv6?] ) || ( mail-mta/sendmail ) )
			sys-libs/db
			bind? ( net-dns/bind[ipv6?] )
			ssl? ( dev-libs/openssl )
			openldap? ( net-nds/openldap[ipv6?] )
			curl? ( net-misc/curl[ipv6?] )
			geoip? ( dev-libs/geoip )
			spf? ( mail-filter/libspf2 )
			dkim? ( mail-filter/dkim-milter[ipv6?] )
			postfix? ( >=mail-mta/postfix-2.5[ipv6?]
						mail-filter/libmilter[ipv6?] )"

DEPEND="sys-devel/flex
		sys-devel/bison
		dev-util/pkgconfig
		${COMMON_DEP}"

RDEPEND="${COMMON_DEP}"

pkg_setup() {
	if use postfix ;then
		einfo "Checking for postfix group ..."
		enewgroup postfix 207 || die "problem adding group postfix"

		einfo "Checking for postdrop group ..."
		enewgroup postdrop 208 || die "problem adding group postdrop"

		einfo "Checking for postfix user ..."
		enewuser postfix 207 -1 /var/spool/postfix postfix,mail \
				|| die "problem adding user postfix"

	else

		einfo "checking for smmsp group...    create if missing."
		enewgroup smmsp 209 || die "problem adding group smmsp"

		einfo "checking for smmsp user...     create if missing."
		enewuser smmsp 209 -1 /var/spool/mqueue smmsp \
		 || die "problem adding user smmsp"
	fi
}

src_configure() {
	local myconf=""

	if use postfix ;then
		myconf+="--with-user=postfix "
	else
		myconf+="--with-user=smmsp "
	fi
	use bind	&& myconf+=" --with-libbind"
	use spf		&& myconf+=" --with-libspf2"
	use dkim	&& myconf+=" --with-libdkim"
	use geoip	&& myconf+=" --with-libGeoIP"
	use ssl		&& myconf+=" --with-openssl"
	use ldap	&& myconf+=" --with-openldap"
	use curl	&& myconf+=" --with-libcurl"

	if use hardened ;then
			myconf+=" --enable-rpath"
		else
			myconf+=" --disable-rpath "
	fi

	econf \
		--with-db \
		--with-libmilter \
		--with-conffile="/etc/${PN}/${PN}.conf" \
		$(use_enable drac) \
		$(use_enable p0f) \
		$(use_enable spamassassin) \
		$(use_enable dnsrbl) \
		$(use_enable postfix) \
		${myconf} || die "muconf failed"
}

src_compile() {
	emake  || die "compile failed"
}
src_install() {

	emake DESTDIR="${D}" install || die "install failed"
	dodoc ChangeLog README

#	newinitd "${FILESDIR}"/gentoo.initd milter-greylist
#	newconfd  "${FILESDIR}"/gentoo.confd milter-greylist
}
pkg_postinst() {
: ;
#	elog "Plz, see READMI files && read man file :)"
}
