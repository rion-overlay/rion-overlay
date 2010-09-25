# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
MODULE_AUTHOR="MSHELOR"

inherit perl-module

DESCRIPTION="Perl implementation of SHA-1/224/256/384/512 "
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

SRC_TEST="do"

src_install() {

	perl-module_src_install
	# file collison witch Digest-SHA
	# required create eselect module or
	# managed symlink other
	rm "${D}/usr/bin/"shasum ||die
	rm "${D}/usr/share/man/man1/"shasum* || die
}
