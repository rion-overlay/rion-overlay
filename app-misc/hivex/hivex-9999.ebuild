# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/hivex/hivex-1.3.2-r1.ebuild,v 1.1 2011/12/01 17:26:53 maksbotan Exp $

EAPI=4

WANT_AUTOMAKE="1.11"
AUTOTOOLS_IN_SOURCE_BUILD=1
EGIT_HAS_SUBMODULES=yes

PYTHON_DEPEND="python? 2:2.6"
inherit base autotools-utils perl-app python git-2

DESCRIPTION="Library for reading and writing Windows Registry 'hive' binary files"
HOMEPAGE="http://libguestfs.org"
EGIT_REPO_URI="https://github.com/libguestfs/hivex.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="ocaml readline perl python test static-libs ruby"

RDEPEND="virtual/libiconv
	virtual/libintl
	dev-libs/libxml2:2
	ocaml? ( dev-lang/ocaml[ocamlopt]
			 dev-ml/findlib[ocamlopt]
			 )
	readline? ( sys-libs/readline )
	perl? ( dev-perl/IO-stringy )
	"

DEPEND="${RDEPEND}
	dev-lang/perl
	perl? (
	 	test? ( dev-perl/Pod-Coverage
				dev-perl/Test-Pod-Coverage ) )
	ruby? ( dev-ruby/rake )
	"
DOCS=(README)

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
		python_need_rebuild
	fi
}

src_prepare() {
	./bootstrap
	autotools-utils_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with readline)
		$(use_enable ocaml)
		$(use_enable perl)
		--enable-nls
		$(use_enable python)
		$(use_enable ruby)
		--disable-rpath )

		autotools-utils_src_configure
}

src_test() {
	autotools-utils_src_compile check
}

src_install() {
	strip-linguas -i po

	autotools-utils_src_install "LINGUAS=""${LINGUAS}"""

	if use perl; then
		fixlocalpod
	fi
}
