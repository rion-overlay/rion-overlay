# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit ruby

DESCRIPTION="Ruby binding to Apache Qpid, Open Source AMQP Messaging"
HOMEPAGE="http://qpid.apache.org/"
SRC_URI="http://www.apache.org/dist/qpid/${PV}/qpid-ruby-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DOCS="RELEASE_NOTES"

DEPEND="dev-ruby/rake"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/qpid-${PV}/ruby

