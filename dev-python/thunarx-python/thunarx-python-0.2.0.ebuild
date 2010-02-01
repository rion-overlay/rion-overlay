# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Python bindings for the Thunar file manager"
HOMEPAGE="http://code.google.com/p/rabbitvcs"
SRC_URI="http://rabbitvcs.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=xfce-base/thunar-0.4.0
	>=dev-python/pygtk-2.6
	>=dev-python/gnome-python-2.12
	>=dev-python/pygobject-2.16"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
	mv "${D}"/usr/share/doc/{${PN},${PF}}
	dodoc AUTHORS ChangeLog NEWS || die
}
