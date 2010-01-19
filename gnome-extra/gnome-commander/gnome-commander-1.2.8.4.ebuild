# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="A full featured, twin-panel file manager for Gnome2"
HOMEPAGE="http://www.nongnu.org/gcmd/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="chm doc exif +gsf id3 pdf python"

ALL_DEPEND="app-text/gnome-doc-utils
	dev-libs/glib:2
	gnome-base/gnome-vfs
	gnome-base/libgnome
	gnome-base/libgnomeui
	x11-libs/gtk+:2
	chm? ( dev-libs/chmlib )
	exif? ( media-gfx/exiv2 )
	gsf? ( gnome-extra/libgsf )
	id3? ( media-libs/taglib )
	pdf? ( virtual/poppler )
	python? ( =dev-lang/python-2* )
	taglib? ( media-libs/taglib )"
DEPEND="${ALL_DEPEND}
		dev-util/intltool
		dev-util/pkgconfig"
RDEPEND="${ALL_DEPEND}"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="$(use_enable doc scrollkeeper )
		$(use_enable python)
		$(use_with chm libchm)
		$(use_with exif exiv2)
		$(use_with gsf libgsf)
		$(use_with id3 taglib)
		$(use_with pdf  poppler)"
}

src_prepare() {
	epatch "${FILESDIR}/asneeded.patch"
	gnome2_src_prepare
}
