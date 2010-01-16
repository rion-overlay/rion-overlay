# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit subversion webapp

DESCRIPTION="Web interface for rtorrent.Writen in Perl"
HOMEPAGE="http://rtpg.uvw.ru/"
ESVN_REPO_URI="http://svn.uvw.ru/rtpg/trunk/"

LICENSE="GPL-3"
KEYWORDS=""
IUSE="apache2 minimal"

DEPEND="dev-perl/Template-Toolkit
		perl-core/CGI
		dev-perl/RTPG
		dev-perl/RPC-XML
		dev-perl/JSON-XS
		apache2? ( www-apache/mod_scgi )
		!minimal? (
				net-p2p/rtorrent[xmlrpc] )"

RDEPEND="${DEPEND}"

need_httpd_cgi

src_unpack() {
	subversion_src_unpack
}
src_install() {
	    webapp_src_preinst
		webapp_postinst_txt ru "${FILESDIR}"/postinst.ru
		webapp_src_install

		dodir etc/"${PN}"
		insinto /etc/"${PN}"
		doins  "${S}"/rtpg.conf

		rm "${S}"/rtpg.conf
		dodoc debian/rtorrent.rc debian/rtpg.apache.conf debian/README.Debian*

		exeinto "${MY_HTDOCSDIR}"
		if use apache2; then
			exeopts -oapache -gapache
		fi

		rm -fr RTPG build debian COPYRIGHT cpan INSTALL*
	    rm -fr LICENSE Localization.txt Makefile
		rm -fr t rtpg.GTK2.pl poabstract RTPG.pm index.cgi

		insinto "${MY_HTDOCSDIR}"
		doins -r .

		cd "${D}/${MY_HTDOCSDIR}"
		for FILE in  RTPG build debian COPYRIGHT cpan INSTALL* \
			                        LICENSE Localization.txt Makefile \
									t rtpg.GTK2.pl poabstract RTPG.pm index.cgi
					do
						rm -rf "${MY_HTDOCSDIR}"/${FILE}
					done
}
