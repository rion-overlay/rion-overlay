# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

DESCRIPTION="Send text message using your mobile phone through a bluetooth connection"
HOMEPAGE="http://code.google.com/p/phonetooth"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="gammu"

RDEPEND="dev-python/pygtk
	 dev-python/pybluez
	 dev-python/pyserial
	 dev-python/dbus-python
	 app-mobilephone/obex-data-server
	 gammu? ( dev-python/python-gammu )"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README
}
