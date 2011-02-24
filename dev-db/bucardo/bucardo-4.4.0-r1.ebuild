# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit perl-app

MY_P="Bucardo-${PV}"
DESCRIPTION="Asynchronous PostgreSQL replication system"
HOMEPAGE="http://bucardo.org/wiki/Bucardo"
SRC_URI="http://bucardo.org/downloads/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/perl-ExtUtils-MakeMaker-6.32
		dev-perl/DBI
		dev-perl/DBD-Pg
		>=dev-perl/DBIx-Safe-1.2.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${MY_P}"

SRC_TEST=""

src_install() {
	einstall || die "Installing failed"
	doinitd "${FILESDIR}"/bucardo || die "Installing init-script failed"
}

pkg_postinst() {
	elog "Remember that PostgreSQL host you intend to use"
	elog "should have Pl/PerlU installed."
	elog "In Gentoo it means"
	elog " dev-db/postgresql-server with USE=\"perl\""
}
