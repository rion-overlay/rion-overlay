# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools-utils git-2

DESCRIPTION="Sagan is a multi-threaded, real time system and event log monitoring system"
HOMEPAGE="http://sagan.softwink.com/"
EGIT_REPO_URI="https://github.com/beave/sagan.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="smtp mysql postgres prelude +lognorm +libdnet +pcap"

DEPEND="dev-util/pkgconfig
	${RDEPEND}"

RDEPEND="dev-libs/libpcre
	app-admin/sagan-rules
	smtp? ( net-libs/libesmtp )
	pcap? ( net-libs/libpcap )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	prelude? ( dev-libs/libprelude )
	lognorm? ( dev-libs/liblognorm )
	libdnet? ( dev-libs/libdnet )"

AUTOTOOLS_IN_SOURCE_BUILD=1
DOCS=(AUTHORS ChangeLog FAQ INSTALL README NEWS TODO)

pkg_setup() {
	enewgroup sagan
	enewuser sagan -1 -1 /dev/null sagan
}

src_prepare() {
	eautoreconf
}

src_configure() {
	 local myeconfargs=(
		$(use_enable mysql)
		$(use_enable postgres postgresql)
		$(use_enable smtp esmtp)
		$(use_enable prelude )
		$(use_enable lognorm)
		$(use_enable libdnet)
		$(use_enable pcap libpcap) )

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	diropts -g sagan -o sagan -m 775

	dodir /var/log/sagan
	dodir /var/run/sagan

	keepdir /var/log/sagan
	keepdir /var/run/sagan

	mkfifo -m 0640 "${D}"/var/run/sagan.fifo
	chown sagan.root "${D}"/var/run/sagan.fifo

	touch "${D}"/var/log/sagan/sagan.log
	chown sagan.sagan "${D}"/var/log/sagan/sagan.log

	newinitd "${FILESDIR}"/sagan.init sagan
	newconfd "${FILESDIR}"/sagan.confd sagan

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

	einfo "https://wiki.quadrantsec.com/bin/view/Main/SaganHOWTO"
	einfo ""

}
