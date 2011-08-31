# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit multilib qt4-r2

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework."
HOMEPAGE="http://code.google.com/p/qxmpp/"
SRC_URI="https://github.com/downloads/0xd34df00d/qxmpp-dev/qxmpp-${PV}-extras.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +extras"

DEPEND=">=x11-libs/qt-core-4.5
		>=x11-libs/qt-gui-4.5
		media-libs/speex"
RDEPEND="${DEPEND}"

src_configure(){
	eqmake4 "${S}"/qxmpp.pro "PREFIX=/usr" "LIBDIR=$(get_libdir)"
}
