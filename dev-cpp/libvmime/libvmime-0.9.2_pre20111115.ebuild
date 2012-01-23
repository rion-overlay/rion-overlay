# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

ZARAFA_PATCHES="zarafa-vmime-patches-0.9.2.tar.bz2"

DESCRIPTION="A powerful C++ class library for working with MIME messages and services like IMAP, POP or SMTP."
HOMEPAGE="http://www.vmime.org/"
SRC_URI="http://rion-overlay.googlecode.com/files/libvmime-0.9.2+svn602.tar.xz
http://rion-overlay.googlecode.com/files/${ZARAFA_PATCHES}"
#	http://dev.gentoo.org/~dagger/files/${ZARAFA_PATCHES}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug doc examples sasl ssl"

RDEPEND="sasl? ( net-libs/libgsasl )
	ssl? ( net-libs/gnutls )
	virtual/libiconv"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${PN}-0.9.2

src_prepare() {
	EPATCH_FORCE=yes
	EPATCH_SUFFIX="diff"
	EPATCH_SOURCE="${WORKDIR}" epatch
#	epatch "${FILESDIR}"/"${PN}"-0.7.1-invlude_signal.patch

	sed -i \
		-e "s|doc/\${PACKAGE_TARNAME}|doc/${PF}|" \
		-e "s|doc/\$(GENERIC_LIBRARY_NAME)|doc/${PF}|" \
		configure Makefile.in || die "sed failed"

}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable sasl)
		$(use_enable ssl tls)
		--enable-platform-posix
		--enable-messaging
		--enable-messaging-proto-pop3
		--enable-messaging-proto-smtp
		--enable-messaging-proto-imap
		--enable-messaging-proto-maildir
		--enable-messaging-proto-sendmail )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc ; then
		doxygen vmime.doxygen || die "doxygen failed"
	fi
}

src_install() {
	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}/doc/html/")
	autotools-utils_src_install
	remove_libtool_files all
}
