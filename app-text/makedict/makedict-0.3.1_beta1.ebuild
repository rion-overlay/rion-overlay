# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Dictionary converter"
HOMEPAGE="http://sourceforge.net/projects/xdxf/"
SRC_URI="http://downloads.sourceforge.net/xdxf/makedict-0.3.1-beta1-Source.tar.bz2"
S="${WORKDIR}/makedict-0.3.1-beta1-Source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack()
{
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/gcc-4.3.1-comp.patch
}

src_compile()
{
	mkdir build
	cd build
	cmake ../ -DCMAKE_INSTALL_PREFIX=/usr
	make || die "make failed"
}

src_install()
{
	cd build
	emake DESTDIR="${D}" install || die "Install failed"
}
