# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit apache-module

DESCRIPTION="mod_ruid2 is a suexec module for apache which takes advantage of POSIX.1e capabilities"
HOMEPAGE="http://sourceforge.net/projects/mod-ruid/"
LICENSE="Apache-2.0"
SRC_URI="mirror://sourceforge/mod-ruid/${P}.tar.bz2"

KEYWORDS="~amd64"
IUSE=""
SLOT="0"

DEPEND="sys-libs/libcap"
RDEPEND="sys-libs/libcap"
DOCFILES="README"
# See apache-module.eclass for more information.
APACHE2_MOD_CONF="55_mod_ruid2"
APACHE2_MOD_DEFINE="RUID2"

need_apache2_2
