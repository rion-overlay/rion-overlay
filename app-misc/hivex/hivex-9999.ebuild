# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="python? 2:2.6"

inherit autotools autotools-utils base perl-app python git-2

DESCRIPTION="Library for reading and writing Windows Registry "hive" binary files."
HOMEPAGE="http://libguestfs.org"
EGIT_REPO_URI="git://git.annexia.org/git/hivex.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="ocaml readline perl python test static-libs ruby"

EGIT_HAS_SUBMODULES="yes"

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
AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_config() {
	python_set_active_version 2
	python_need_rebuild
}

src_prepare() {
	autotools-utils_src_prepare
	eautopoint
	_elibtoolize
	gnulibtolize
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

gnulibtolize() {
	modules='
	byteswap
	c-ctype
	fcntl
	full-read
	full-write
	gitlog-to-changelog
	gnu-make
	gnumakefile
	ignore-value
	inttypes
	maintainer-makefile
	manywarnings
	progname
	strndup
	vasprintf
	vc-list-files
	warnings
	xstrtol
	xstrtoll'

./.gnulib//gnulib-tool \
--libtool                     \
--avoid=dummy                 \
--with-tests                  \
--m4-base=m4                  \
--source-base=gnulib/lib      \
--tests-base=gnulib/tests     \
--import $modules
}
