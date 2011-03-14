# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils eutils

DESCRIPTION="Trac-based continuous integration framework"
HOMEPAGE="http://bitten.edgewall.org"
MY_P=${PN/b/B}-${PV/_beta/b}
SRC_URI="http://ftp.edgewall.com/pub/bitten/${MY_P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~x86 ~amd64"
IUSE="master test"

SLOT="0"

PYTHON_DEPEND="2"
DISTUTILS_SRC_TEST="setup.py"
RESTRICT_PYTHON_ABIS="3.*"
SUPPORT_PYTHON_ABIS="1"

RDEPEND="master? ( www-apps/trac )"

BDEPEND="
	dev-python/setuptools-0.6"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/hg_pull.trac_0.12.patch
}

pkg_setup() {
	DISTUTILS_GLOBAL_OPTIONS=($(use_with master))
}

pkg_postinst() {
	if use master ; then
		elog "To enable the Bitten plugin in your Trac environments, you have to add:"
		elog "    [components]"
		elog "    bitten.* = enabled"
		elog "to your trac.ini file"
	fi
}
