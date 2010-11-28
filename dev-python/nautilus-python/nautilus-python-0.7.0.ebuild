# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nautilus-python/nautilus-python-0.6.1.ebuild,v 1.2 2010/03/28 13:45:38 pva Exp $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="Python bindings for the Nautilus file manager"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DOCS="AUTHORS ChangeLog NEWS"
G2CONF="--docdir=${EPREFIX}/usr/share/doc/${PF}"

# dev-python/gnome-python-base is not required actually, but configure script
# checks for it for some unknown reason
COMMON_DEPEND="dev-python/pygtk
	dev-python/pygobject
	gnome-base/nautilus"
DEPEND="${COMMON_DEPEND}
	dev-python/gnome-python-base
	doc? ( >=dev-util/gtk-doc-1.9 )"
RDEPEND="${COMMON_DEPEND}"

src_install() {
	gnome2_src_install
	mv "${D}"/usr/share/doc/${PN}/* "${D}"/usr/share/doc/${PF}/
	rm -rf "${D}"/usr/share/doc/${PN}
}
