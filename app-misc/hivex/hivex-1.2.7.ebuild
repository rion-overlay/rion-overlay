# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_AUTOMAKE="1.11"
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit base autotools-utils  perl-app python

PYTHON_DEPEND="2.6"

DESCRIPTION="Library for reading and writing Windows Registry "hive" binary files."
HOMEPAGE="http://libguestfs.org"
SRC_URI="http://libguestfs.org/download/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ocaml +readline nls +perl test static-libs"

#LANGS="es fr gu hi kn ml mr nl or pl ru uk pt_BR zh_CN"

#for X in ${LANGS} ; do
#	IUSE="${IUSE} linguas_${X}"
#done

RDEPEND="dev-lang/perl
	virtual/libiconv
	>=sys-devel/gettext-0.18
	virtual/libintl
	dev-libs/libxml2:2
	ocaml? ( dev-lang/ocaml[ocamlopt]
			 dev-ml/findlib[ocamlopt]
			 )
	readline? ( sys-libs/readline )
	perl? ( dev-perl/IO-stringy )
	"

DEPEND="${RDEPEND}
	 perl? (
	 	test? ( dev-perl/Pod-Coverage
				dev-perl/Test-Pod-Coverage ) )
		"
#PATCHES=("${FILESDIR}"/autoconf_fix-${PV}.patch)
DOCS=(README)

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
		$(use_with readline) \
		$(use_enable ocaml) \
		$(use_enable perl) \
		$(use_enable nls) \
		--disable-rpath \
		--enable-gcc-warnings\
		)
		autotools-utils_src_configure
}

src_test() {
	emake check || die
}

src_install() {
	if use nls; then
		strip-linguas -i po
		if [ -z "${LINGUAS}" ] ; then
			LINGUAS=none
		fi
	else
		LINGUAS=none
	fi

	autotools-utils_src_install "LINGUAS=""${LINGUAS}"""

	if use perl; then
		fixlocalpod
	fi
}
