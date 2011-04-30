# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools-utils

DESCRIPTION="Provide a faked chroot environment without requiring root privileges"
HOMEPAGE="http://fakechroot.alioth.debian.org/"
SRC_URI="mirror://debian/pool/main/f/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(NEWS README THANKS)
PATCHES=(${FILESDIR}/gentoo_fix_chroot_location_in_test.patch)

src_prepare() {
	autotools-utils_src_prepare
	eautoreconf
}

