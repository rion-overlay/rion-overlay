# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit qt4-r2

DESCRIPTION="OTR Plugin for Psi"
HOMEPAGE="http://public.tfh-berlin.de/~s30935/"
SRC_URI="http://public.tfh-berlin.de/~s30935/files/psi-otr-0.6.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/htmltidy
	net-libs/libotr
	x11-libs/qt-gui"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e 's#\.\./\.\./psiplugin.pri#/usr/share/psi/plugins/psiplugin.pri#' \
	                -i "${PN}".pro || die
	qt4-r2_src_prepare
}
