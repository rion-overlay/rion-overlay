# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp

DESCRIPTION="Web interface for rtorrent. Writen in Perl"
HOMEPAGE="http://rtpg.uvw.ru/"
SRC_URI="mirror://debian/pool/main/r/${PN}/${PN}_${PV}.orig.tar.gz
	http://code.jquery.com/jquery-1.4.2.min.js -> jquery.min.js"

#http://www.famfamfam.com/lab/icons/flags/famfamfam_flag_icons.zip
#
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="apache2 minimal geoip"

DEPEND="dev-perl/Template-Toolkit[gd]
	perl-core/CGI
	>=dev-perl/RTPG-0.9
	>=dev-perl/RPC-XML-0.72
	dev-perl/JSON-XS
	dev-perl/MIME-Types
	dev-perl/Tree-Simple
	dev-perl/Locale-PO
	virtual/httpd-cgi
	!minimal? ( net-p2p/rtorrent[xmlrpc] )"

RDEPEND="${DEPEND}"

need_httpd_cgi

src_unpack() {
	unpack ${PN}_${PV}.orig.tar.gz
}

src_compile() {
	:;
}

src_install() {
	webapp_src_preinst
	webapp_postinst_txt ru "${FILESDIR}"/postinst.ru
	insinto "${MY_HTDOCSDIR}"
	doins -r  "${S}/htdocs"/*

	insinto "${MY_HOSTROOTDIR}"
	doins -r cache
	doins -r lib po templates

	webapp_src_install

	insinto /usr/share/javascript/jquery/
	doins "${DISTDIR}"/jquery.min.js || die

	dodoc doc/* || die
	dodoc config/* ||die
}
