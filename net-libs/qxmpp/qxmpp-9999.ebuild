# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2 subversion

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework."
HOMEPAGE="http://code.google.com/p/qxmpp/"
ESVN_REPO_URI="http://qxmpp.googlecode.com/svn/trunk/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND=">=x11-libs/qt-core-4.5
		>=x11-libs/qt-gui-4.5"
RDEPEND="${DEPEND}"
