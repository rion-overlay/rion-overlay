# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

DESCRIPTION="SBLIM CMPI Provider Development Support"
HOMEPAGE="http://sourceforge.net/projects/sblim/"
SRC_URI="mirror://sourceforge/project/sblim/development%20pkgs/${PN}/${PV}/${P}.tar.bz2"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="!!sys-apps/tog-pegasus"
RDEPEND="${DEPEND}"
