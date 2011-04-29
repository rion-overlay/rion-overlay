# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit apache-module

DESCRIPTION="The module limits the number of threads in READ state on a per IP basis."
HOMEPAGE="http://sourceforge.net/projects/mod-antiloris"
SRC_URI="mirror://sourceforge/mod-antiloris/${P}.tar.bz2"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE=""
SLOT="0"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="80_${PN}"
APACHE2_MOD_DEFINE="ALORIS"
DOCFILES="ChangeLog"

need_apache2
