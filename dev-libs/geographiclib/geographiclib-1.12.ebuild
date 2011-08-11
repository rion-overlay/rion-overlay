# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Small set of C++ classes for performing various geographic and geodesic conversions"
HOMEPAGE="http://geographiclib.sourceforge.net/"
MY_P="GeographicLib-${PV}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die
	rm -rf "${D}"/usr/share/doc/
	if use doc; then
		dohtml -r doc/* || die "Installing HTML documentation failed"
	fi
}
