# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_AUTOMAKE="1.11"
inherit autotools perl-app 
# bash-completion python java-pkg-2 haskell-cabal

DESCRIPTION="Library for reading and writing Windows Registry "hive" binary files."
HOMEPAGE="http://libguestfs.org"
SRC_URI="http://libguestfs.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ocaml readline perl"

DEPEND="dev-lang/perl
	virtual/libiconv
	>=sys-devel/gettext-0.18
	virtual/libintl
	dev-libs/libxml2:2
	ocaml? ( dev-lang/ocaml )
	readline? ( sys-libs/readline )
	perl? ( dev-perl/IO-stringy )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/autoconf_fix.patch || die
	eautoreconf
}

src_configure() {
	econf -C \
		$(use_with readline) \
		$(use_with ocaml) \
		$(use_with perl) \
		--disable-rpath || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
