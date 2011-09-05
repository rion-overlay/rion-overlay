# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_AUTOMAKE="1.11"
PYTHON_DEPEND="python? 2:2.6"

inherit base autotools-utils  perl-app python

DESCRIPTION="Library for reading and writing Windows Registry "hive" binary files."
HOMEPAGE="http://libguestfs.org"
SRC_URI="http://libguestfs.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
PATCHES=("${FILESDIR}"/autoconf_fix-${PV}.patch "${FILESDIR}"/incorrect_format.patch)
DOCS=(README)
AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_config() {
	python_set_active_version 2
	python_need_rebuild
}

src_prepare() {
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
		--disable-rpath
		)

		autotools-utils_src_configure
}

src_test() {
	emake check || die
}

src_install() {
	strip-linguas -i po
	if [ -z "${LINGUAS}" ] ; then
		LINGUAS=none
	fi

	autotools-utils_src_install "LINGUAS=""${LINGUAS}"""

	if use perl; then
		fixlocalpod
	fi
}
