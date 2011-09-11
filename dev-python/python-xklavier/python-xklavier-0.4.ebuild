# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.5"
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit python

DESCRIPTION="Python bindings to libxklavier"
HOMEPAGE="http://devel.randomink.org/projects/python-xklavier"
SRC_URI="http://devel.randomink.org/attachments/download/6/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libxklavier
		dev-python/pygobject"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "make failed"
	dodoc AUTHORS ChangeLog NEWS README || die "Installing docs failed"
}
