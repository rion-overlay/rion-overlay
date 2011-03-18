# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="http://sagan.softwink.com/"
SRC_URI="http://sagan.softwink.com/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="smtp mysql postgres prelude +lognorm libdnet pcap"

DEPEND="dev-util/pkgconfig"
RDEPEND="dev-libs/libpcre
	app-admin/sagan-rules
	smtp? ( net-libs/libesmtp )
	pcap? ( net-libs/libpcap )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	prelude? ( dev-libs/libprelude )
	lognorm? ( dev-libs/liblognorm )
	libdnet? ( dev-libs/libdnet )"

pkg_setup() {
	enewgroup sagan
	enewuser sagan -1 -1 /dev/null sagan
	einfo "user sagan created"
}

src_prepare() {
	esvn_clean "${S}"
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable mysql) \
		$(use_enable postgres postgresql)  \
		$(use_enable smtp esmtp) \
		$(use_enable prelude ) \
		$(use_enable lognorm) \
		$(use_enable libdnet) \
		$(use_enable pcap libpcap) || die "econf failed"
}

src_install() {
	emake DESTDIR="${ED}" install ||die "emake install failed"
	diropts -g sagan -o sagan -m 775

	dodir /var/log/sagan
	dodir /var/run/sagan

	keepdir /var/log/sagan
	keepdir /var/run/sagan

	mkfifo -m 0640 "${ED}"/var/run/sagan.fifo || die
	chown sagan.root "${ED}"/var/run/sagan.fifo || die

	touch "${ED}"/var/log/sagan/sagan.log || die
	chown sagan.sagan "${ED}"/var/log/sagan/sagan.log || die

	newinitd "${FILESDIR}"/sagan.init sagan || die
	newconfd "${FILESDIR}"/sagan.confd sagan || die

	insinto /usr/share/doc/${P}/examples
	doins -r extra/*
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

	einfo "For configuration please read Sagan HOWTOO"
	einfo "https://wiki.softwink.com/bin/view/Main/SaganHOWTO"
}
