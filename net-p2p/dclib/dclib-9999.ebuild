# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/dclib/dclib-0.3.21.ebuild,v 1.1 2008/09/24 19:59:13 armin76 Exp $

EAPI="2"

inherit subversion autotools

DESCRIPTION="DirectConnect client library"
HOMEPAGE="http://sourceforge.net/projects/wxdcgui"
ESVN_REPO_URI="https://wxdcgui.svn.sourceforge.net/svnroot/wxdcgui/trunk/dclib/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug ssl"

DEPEND=">=app-arch/bzip2-1.0.2
		>=dev-libs/libxml2-2.4.22
		virtual/libiconv
	 	ssl? ( >=dev-libs/openssl-0.9.8j )"

RDEPEND="${DEPEND}"

src_unpack() {
	subversion_src_unpack
}
src_prepare() {
	eautoreconf
}

src_configure() {
	econf   --disable-rpath \
			--disable-socks \
			$(use_enable debug) \
			 $(use_enable ssl) || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
