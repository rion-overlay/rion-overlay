# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit libtool

DESCRIPTION="System Security Services Daemon -  provide access to identity and authentication"
HOMEPAGE="https://fedorahosted.org/sssd"
SRC_URI="https://fedorahosted.org/released/sssd/sssd-${PV}.tar.gz"

LICENSE="LGPL-3  GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/sssd-${PV}"/common

src_prepare() {
	elibtoolize
}

src_install() {
	emake DESTDIR="${D}" install || die
}
