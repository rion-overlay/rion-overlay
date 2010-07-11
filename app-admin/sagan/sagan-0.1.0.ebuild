# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="http://sagan.softwink.com/"
SRC_URI="http://sagan.softwink.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="smtp mysql postgres"

DEPEND="dev-util/pkgconfig"
RDEPEND="dev-libs/libpcre
	app-admin/sagan-rules
	smtp? ( net-libs/libesmtp )
	mysql? ( virtual/mysql )
	postgers? ( dev-db/postgresql-base )"

pkg_setup() {
	enewgroup sagan
	enewuser sagan -1 -1 /dev/null sagan
	einfo "user sagan created"
}

src_prepare() {
	epatch "${FILESDIR}"/install_destdir_fix.patch || die "epatch failed"
	epatch "${FILESDIR}"/sysconfig_location.patch || die
	eautoreconf
	# sed -e -i 's/usr\/local/d' etc/sagan.conf
}

src_configure() {
	econf \
		--enable-logzilla \
		$(use_enable mysql) \
		$(use_enable postgres postgresql)  \
		$(use_enable smtp esmtp) || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install ||die "emake install failed"
	diropts -g sagan -o sagan -m 775

	dodir /var/log/sagan
	dodir /var/run/sagan

	keepdir /var/log/sagan
	keepdir /var/run/sagan

	newinitd "${FILESDIR}"/sagan.init sagan || die
	newconfd "${FILESDIR}"/sagan.confd sagan || die
}

pkg_postinst() {

	if use smtp; then
		ewarn "You have smtp use flag"
		ewarn "If you plan on using Sagan with the libesmtp (E-mail),"
		ewarn "the Sagan user will need a valid, user writeable home directory."
		ewarn "for security reason, ebuild create sagan user's with /dev/null"
		ewarn "home"
		ewarn "run as root "
		ewarn " chsh -s /bin/bash sagan"
		ewarn "and create home directory manuallu"
	fi

	einfo "for configuration please read Sagan HOWTOO"
	einfo "https://wiki.softwink.com/bin/view/Main/SaganHOWTO"
}
