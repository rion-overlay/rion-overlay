# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/atftp/atftp-0.7-r1.ebuild,v 1.9 2008/11/26 22:11:09 flameeyes Exp $

EAPI="3"

inherit eutils flag-o-matic

DEBIAN_PV="11"
DEBIAN_A="${PN}_${PV}-${DEBIAN_PV}.diff.gz"

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="ftp://ftp.mamalinux.com/pub/atftp/"
SRC_URI="ftp://ftp.mamalinux.com/pub/atftp/${P}.tar.gz
	mirror://debian/pool/main/a/${PN}/${DEBIAN_A}
	ris? ( http://oss.netfarm.it/guides/ris-linux-0.4.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux tcpd readline pcre ris"

RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
	selinux? ( sec-policy/selinux-tftpd )
	readline? ( sys-libs/readline )
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	!virtual/tftp"
PROVIDE="virtual/tftp"

src_prepare(){
	epatch "${DISTDIR}"/${DEBIAN_A}
	epatch "${FILESDIR}"/${P}-pcre.patch
	epatch "${FILESDIR}"/${P}-password.patch
	epatch "${FILESDIR}"/${P}-tests.patch
	epatch "${FILESDIR}"/${P}-glibc24.patch
	# remove upstream's broken CFLAGS
	sed -i.orig -e \
	  '/^CFLAGS="-g -Wall -D_REENTRANT"/s,".*","",g' \
	  "${S}"/configure

	use ris && epatch "${WORKDIR}"/ris-linux-0.4/patches/atftpd-filecase.diff
}

src_configure(){
	econf \
		$(use_enable tcpd libwrap) \
		$(use_enable readline libreadline) \
		$(use_enable pcre libpcre) \
		--enable-mtftp \
		|| die "./configure failed"
}

src_compile() {
	append-flags -D_REENTRANT -DRATE_CONTROL
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	emake install DESTDIR="${D}" || die "Installation failed"
	newinitd "${FILESDIR}"/atftp.init atftp
	newconfd "${FILESDIR}"/atftp.confd atftp

	dodoc README* BUGS FAQ Changelog INSTALL TODO
	dodoc "${S}"/docs/*

	docinto test
	cd "${S}"/test
	dodoc load.sh mtftp.conf pcre_pattern.txt test.sh test_suite.txt
}
