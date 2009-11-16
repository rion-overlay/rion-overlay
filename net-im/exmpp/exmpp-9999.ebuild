# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools subversion

DESCRIPTION="fast and scalable XMPP library written in Erlang/OTP"
HOMEPAGE="https://support.process-one.net/doc/display/EXMPP"
ESVN_REPO_URI="http://svn.process-one.net/exmpp/trunk"

LICENSE="EPL"
SLOT="0"
KEYWORDS=""
IUSE="examples doc"

DEPEND=">=sys-devel/autoconf-2.64
	dev-lang/erlang
	dev-libs/expat
	dev-libs/libxml2
	dev-libs/openssl
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --prefix=/usr/$(get_libdir)/erlang/lib --libdir=/usr/$(get_libdir) \
		$(use_enable examples) \
		$(use_enable doc documentation) \
			|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || "install failed"
}
