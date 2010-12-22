# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils distutils

DESCRIPTION="A Python XMPP (RFC 3920,3921) and Jabber implementation"
HOMEPAGE="http://pyxmpp.jajcus.net/"
SRC_URI="http://pyxmpp.jajcus.net/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-lang/python-2.3
	>=dev-libs/libxml2-2.6.23[python]"
RDEPEND="${DEPEND}
	>=dev-python/dnspython-1.3.2
	>=dev-python/m2crypto-0.13.1"

src_install() {
	DOCS="CHANGES"
	distutils_src_install
	if use doc; then
		dohtml -r doc/www/* || die "Dohtml failed"
	fi
}
