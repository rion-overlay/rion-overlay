# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR="DANBERR"
inherit perl-module

DESCRIPTION="Sys::Virt provides an API for using the libvirt library from Perl"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ALL_DEPEND=">=app-emulation/libvirt-0.9.5"
DEPEND="${ALL_DEPEND}
	virtual/perl-Time-HiRes
	dev-perl/XML-XPath
	dev-util/pkgconfig"
RDEPEND="${ALL_DEPEND}"
SRC_TEST="do"

src_compile() {
	perl_set_version

	make OTHERLDFLAGS="${LDFLAGS}" ${mymake}
}
