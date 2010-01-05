# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="Stressful Application Test, used at Google for some time"
HOMEPAGE="http://code.google.com/p/stressapptest"
SRC_URI="http://stressapptest.googlecode.com/files/${P}_autoconf.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${P}"_autoconf

src_prepare() {
	eautoreconf
}

src_install() {
	einstall || die
}
