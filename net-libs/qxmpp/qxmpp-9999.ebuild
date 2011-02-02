# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2 subversion git

DESCRIPTION="A cross-platform C++ XMPP client library based on the Qt framework."
HOMEPAGE="http://code.google.com/p/qxmpp/"
ESVN_REPO_URI="http://qxmpp.googlecode.com/svn/trunk/"
EGIT_REPO_URI="git://github.com/0xd34df00d/qxmpp-dev.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug +extras"

DEPEND=">=x11-libs/qt-core-4.5
		>=x11-libs/qt-gui-4.5"
RDEPEND="${DEPEND}"

src_unpack(){
	if ! use extras; then
		subversion_src_unpack
	else
		git_src_unpack
	fi
}

src_prepare(){
	if ! use extras; then
		subversion_src_prepare
	else
		git_src_prepare
	fi
}
