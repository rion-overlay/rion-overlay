# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

DESCRIPTION="Address Family Transition Router"
HOMEPAGE="http://www.isc.org/software/aftr"
SRC_URI="http://ftp.isc.org/isc/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="kernel_linux? ( >=virtual/linux-sources-2.6.26 )
		=dev-lang/python-2*"
RDEPEND="${DEPEND}"

src_install() {
	dosbin aftr
	dosbin xpmpd.py
	insinto /etc
	doins confh/aftr.conf

#	newinitd "${FILESDIR}"/aftr.initd aftr # In progress
	doman man/*
	dohtml html/*.html
	dodoc CHANGES README README.B4 README.natcntl  xpmpd.py README.natcntl
}
