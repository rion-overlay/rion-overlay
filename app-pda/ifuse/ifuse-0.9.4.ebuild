# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools
if [[ "${PV}" == 9999* ]]; then
	inherit git
	EGIT_REPO_URI="git://github.com/MattColyer/ifuse.git"
else
	SRC_URI="http://cloud.github.com/downloads/MattColyer/${PN}/${P}.tar.bz2"
fi

DESCRIPTION="fuse module for access to iphone and ipod touch without jailbreak"
HOMEPAGE="http://matt.colyer.name/projects/iphone-linux/"
EGIT_REPO_URI="git://github.com/MattColyer/ifuse.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="app-pda/libplist
	app-pda/libiphone
	sys-fs/fuse
	dev-libs/glib:2"
DEPEND="${RDEPEND}"

src_unpack() {
	if [[ "${PV}" == 9999* ]]; then
		git_src_unpack
	else
		unpack ${A}
		# for ebuild autor - read pms,plz and not! quoted A wariable
	fi
}

src_prepare() {
	cd "${S}"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}

pkg_postinst() {
	ewarn "Only use this filesystem driver to create backups of your data."
	ewarn "The music database is hashed, and attempting to add files will "
	ewarn "cause the iPod/iPhone to consider your database unauthorised."
	ewarn "It will respond by wiping all media files, requiring a restore "
	ewarn "through iTunes. You have been warned."
}

