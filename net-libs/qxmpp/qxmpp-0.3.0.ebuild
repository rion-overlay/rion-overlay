# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework."
HOMEPAGE="http://code.google.com/p/qxmpp/"
SRC_URI="extras? ( https://github.com/downloads/0xd34df00d/qxmpp-dev/qxmpp-0.3.0-extras.tar.bz2 )
		 !extras? ( https://github.com/downloads/0xd34df00d/qxmpp-dev/qxmpp-0.3.0-upstream.tar.bz2 )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +extras"

DEPEND=">=x11-libs/qt-core-4.5
		>=x11-libs/qt-gui-4.5"
RDEPEND="${DEPEND}"
