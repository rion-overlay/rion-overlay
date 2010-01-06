# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/xmltv/xmltv-0.5.39.ebuild,v 1.6 2006/02/13 14:51:44 mcummings Exp $

inherit distutils

MY_P=${P}
DESCRIPTION="Python module that provides access to XMLTV data."
S=${WORKDIR}/${MY_P}
HOMEPAGE="http://www.funktronics.ca/python-xmltv/"
SRC_URI="http://www.funktronics.ca/python-xmltv/releases/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE=""

DEPEND="virtual/python
		dev-python/elementtree"
RDEPEND="${DEPEND}"
