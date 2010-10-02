# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
MY_PN="${PN}-1.1b1"

DESCRIPTION="Address Family Transition Router"
HOMEPAGE="http://www.isc.org/software/aftr"
SRC_URI="http://ftp.isc.org/isc/${PN}/${MY_PN}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="kernel_linux? ( >=virtual/linux-sources-2.6.26 )
		=dev-lang/python-2*"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"
src_install() {
	dosbin aftr
	dosbin xpmpd.py
	insinto /etc
	doins confh/aftr.conf

#	newinitd "${FILESDIR}"/aftr.initd aftr # In progress
	doman man/*
	dohtml html/*.html
	dodoc CHANGES README README.B4 README.natcntl xpmpd.py || die
	dodoc searchlog.py ||die
	insinto /usr/share/doc/"${P}"
	doins -r confh
	doins -r confs

	prepalldocs
}
