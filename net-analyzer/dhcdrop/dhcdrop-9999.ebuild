# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit  autotools subversion

DESCRIPTION="Drop not valid DHCP server in you network"
HOMEPAGE="http://www.netpatch.ru/dhcdrop.html"
ESVN_REPO_URI="https://svn.codenet.ru/netpatch/dhcdrop/trunk/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=net-libs/libpcap-0.9.8"
RDEPEND="${DEPEND}"

WANT_AUTOCONF=2.63

S="$WORKDIR"/"${P}"
src_unpack() {
subversion_src_unpack
eautoreconf
}

src_install() {
	einstall || die
	dodoc ChangeLog  ChangeLog-ru

}

