# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit qt4-r2 cmake-utils subversion

DESCRIPTION="Qt4 based client for DirectConnect and ADC protocols, based on DC++ library"
HOMEPAGE="http://${PN}.googlecode.com/"
KEYWORDS=""
SRC_URI=""
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/qt-gui:4
	dev-libs/openssl
	net-libs/libupnp"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"