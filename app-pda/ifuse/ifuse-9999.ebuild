# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools git

DESCRIPTION="fuse module for access to iphone and ipod touch without jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
EGIT_REPO_URI="git://github.com/MattColyer/ifuse.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-pda/libplist
		app-pda/libiphone
		sys-fs/fuse
		dev-libs/glib:2"

DEPEND="${RDEPEND}"

src_unpack() {
	git_src_unpack
}

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}

pkg_postinst() {
	ewarn "Only use this filesystem driver to create backups of your data."
	ewarn "The music database is hashed, and attempting to add files will "
	ewarn "cause the iPod/iPhone to consider your database unauthorised."
	ewarn "It will respond by wiping all media files, requiring a restore "
	ewarn "through iTunes. You have been warned."
}
