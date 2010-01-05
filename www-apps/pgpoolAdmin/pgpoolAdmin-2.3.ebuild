# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
# I`m know about depend.php eclass
inherit  webapp eutils

DESCRIPTION="Web interface for pgpool, written in PHP"
HOMEPAGE="http://pgfoundry.org/projects/pgpool/"
SRC_URI="http://pgfoundry.org/frs/download.php/2494/pgpoolAdmin-2.3.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/php[postgres]"
RDEPEND="${DEPEND}"

need_httpd
src_install() {
	webapp_src_preinst

	cd "${S}"
	cp -R . "${D}/${MY_HTDOCSDIR}"

	webapp_serverowned -R "${MY_HTDOCSDIR}" || die

	webapp_serverowned  "${MY_HTDOCSDIR}"/.htaccess
	webapp_src_install

	elog "This ebuild is experimental"
	elog "and not fully complete"
	elog "Plz, fix setting manually"
}
