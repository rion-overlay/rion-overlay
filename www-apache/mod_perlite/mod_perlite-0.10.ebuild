# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit  perl-module apache-module

DESCRIPTION="mod_perlite, the equivalent of mod_php for Perl"
HOMEPAGE="http://modperlite.org/"
LICENSE="GPL-3"
SRC_URI="http://download.github.com/sodabrew-mod_perlite-080fe20.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND="dev-perl/File-Which"
RDEPEND=""

S="${WORKDIR}"/sodabrew-mod_perlite-080fe20

APACHE2_MOD_CONF="75_${PN}"
APACHE2_MOD_DEFINE="PERLITE"
APACHE2_MOD_FILE="${S}/mod_perlite.so"

SRC_TEST="do"
DOCFILES="README TODO Changes"
need_apache2

src_prepare() {
	perl-module_src_prep
}

src_compile() {
	perl-module_src_compile
}

src_install() {
	apache-module_src_install

	# Install Perl modules
	insinto "${ARCH_LIB}"
	doins -r "${S}"/blib/lib/*

}
