# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Author: mva $
EAPI="3"

inherit subversion

DESCRIPTION="Asterisk's GUI."
ESVN_REPO_URI="http://svn.digium.com/svn/asterisk-gui/branches/2.0"
HOMEPAGE="http://www.digium.com/"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=net-misc/asterisk-1.6.2.0"
DEPEND="${RDEPEND}"

src_configure() {
econf --localstatedir=/var/lib
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed" 
	insinto "/etc/asterisk"
	newins providers.conf.sample providers.conf
	dodoc README LICENSE COPYING CREDITS requests.txt security.txt other/sqlite.js
}