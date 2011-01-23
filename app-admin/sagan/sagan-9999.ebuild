# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils autotools subversion

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="http://sagan.softwink.com/"
ESVN_REPO_URI="http://svn.softwink.com/svn/repos/sagan/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="smtp mysql postgres prelude lognorm pcap"

DEPEND="dev-util/pkgconfig"
RDEPEND="dev-libs/libpcre
	app-admin/sagan-rules
	smtp? ( net-libs/libesmtp )
	pcap? ( net-libs/libpcap )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	prelude? ( dev-libs/libprelude )
	lognorm? ( dev-libs/liblognorm )"

pkg_setup() {
	enewgroup sagan
	enewuser sagan -1 -1 /dev/null sagan
	einfo "user sagan created"
}

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable mysql) \
		$(use_enable postgres postgresql)  \
		$(use_enable smtp esmtp) \
		$(use_enable prelude ) \
		$(use_enable lognorm) \
		$(use_enable pcap libpcap) || die "econf failed"
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

	insinto /usr/share/${P}/exapmples
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
