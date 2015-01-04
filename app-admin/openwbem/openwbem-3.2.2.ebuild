# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# БЫДЛОКОД, БЛЯ, ПРОТУХШУЙ

EAPI=5

AUTOTOOLS_IN_SOURCE_BUILD=1
WANT_AUTOMAKE=1.9

inherit autotools autotools-utils

DESCRIPTION="The OpenWBEM CIMOM"
HOMEPAGE="http://www.openwbem.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+association-traversal +cmpi debug +digest static-libs slp ssl pam perl valgrind zlib"

CDEPEND="
	ssl? ( dev-libs/openssl )
	slp? ( net-libs/openslp )
	"

DEPEND="${CDEPEND}"

src_configure() {

# if glibc, enable --enable-threads-run-as-user

# It's slotting way ? --with-package-prefix=PREFIX

	local myeconfargs=(
		$(use_enable perl perl-providerifc)
		$(use_enable pam)
		$(use_enable zlib)
		$(use_enable debug debug-mode)
		$(use_enable debug memory-debug-mode)
		$(use_enable debug func-name-debug-mode)
		$(use_enable debug stack-trace)
		$(use_enable static-libs fake-libs)
		$(use_enable static-libs static-services)
		$(use_enable slp openslp)
		$(use_enable digest)
		$(use_enable association-traversal)
		$(use_enable cmpi)
		$(use_enable valgrind)
		--enable-threads-run-as-user
		)
	autotools-utils_src_configure
}
