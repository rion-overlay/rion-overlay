# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_AUTOMAKE="1.11"

inherit autotools perl-app python

PYTHON_DEPEND="2"

DESCRIPTION="Library for reading and writing Windows Registry "hive" binary files."
HOMEPAGE="http://libguestfs.org"
SRC_URI="http://libguestfs.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ocaml readline nls +perl test"

RDEPEND="dev-lang/perl
	virtual/libiconv
	>=sys-devel/gettext-0.18
	virtual/libintl
	dev-libs/libxml2:2
	ocaml? ( dev-lang/ocaml[ocamlopt]
			 dev-ml/findlib[ocamlopt]
			 )
	readline? ( sys-libs/readline )
	perl? ( dev-perl/IO-stringy )"

DEPEND="${RDEPEND}
	 perl? (
	 	test? ( dev-perl/Pod-Coverage
				dev-perl/Test-Pod-Coverage )
			)"

pkg_config() {
	python_set_active_version 2
	python_need_rebuild
}

src_prepare() {
	epatch "${FILESDIR}"/autoconf_fix.patch || die
	eautoreconf
}

src_configure() {
	econf -C \
		$(use_with readline) \
		$(use_enable ocaml) \
		$(use_enable perl) \
		$(use_enable nls) \
		--disable-rpath || die
}

src_test() {
	emake check || die
}

src_install() {
	emake DESTDIR="${ED}" install || die

	if use perl; then
		fixlocalpod
	fi
	dodoc README
}
