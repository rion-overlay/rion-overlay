# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp

DESCRIPTION="RRDtool frontend for Postfix queue-statistics"
HOMEPAGE="http://www.arschkrebs.de/postfix/queuegraph/"
SRC_URI="http://www.arschkrebs.de/postfix/queuegraph/queuegraph.tar.gz"

LICENSE="as-is"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-analyzer/rrdtool[perl]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

pkg_setup() {
	webapp_pkg_setup
	enewgroup mgraph
	enewuser mgraph -1 -1 /var/empty mgraph,adm
}

src_prepare() {
	sed -i  -e "s|etc/postfix/mailqueues.rrd|var/lib/queuegraph/queuegraph.rrd|" \
							queuegraph-rrd.sh || die "sed queuegraph-rrd.sh failed"
	sed -i  -e "s|\(my \$rrd = '\).*'|\1/var/lib/queuegraph/queuegraph.rrd'|" \
							queuegraph.cgi || die "sed queuegraph.cgi failed"
}
src_install() {
	webapp_src_preinst
	# be sure to run webapp_src_install *before* doing the directories below
	# because it cripples all other permissions :-(
	webapp_src_install

	# for the RRDs
	dodir /var/lib
	diropts -omgraph -gmgraph -m0750
	dodir /var/lib/queuegraph
	keepdir /var/lib/queuegraph

	exeinto ${MY_CGIBINDIR}
	doexe queuegraph.cgi

	exeinto /etc/cron.hourly
	doexe queuegraph-rrd.sh

	dodoc README
}
