# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN="WebGUI"
#stable or beta
REL="beta"
inherit  depend.apache webapp

DESCRIPTION="CMS in Perl"
HOMEPAGE="http://www.webgui.org/"
SRC_URI="http://update.webgui.org/7.x.x/${P}-${REL}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="${DEPEND}"
DEPEND=">=dev-lang/perl-5.8.8-r5
	dev-perl/libwww-perl
	virtual/perl-Test-Simple
	dev-perl/Test-MockObject
	dev-perl/Test-Deep
	dev-perl/Test-Exception
	dev-perl/Test-Class
	dev-perl/Pod-Coverage
	virtual/perl-Text-Balanced
	virtual/perl-Digest-MD5
	dev-perl/DBI
	dev-perl/DBD-mysql
	dev-perl/HTML-Parser
	virtual/perl-Archive-Tar
	dev-perl/Archive-Zip
	virtual/perl-IO-Zlib
	dev-perl/Net-SMTP-SSL
	dev-perl/MIME-tools
	dev-perl/Tie-IxHash
	dev-perl/XML-Simple
	dev-perl/DateTime
	virtual/perl-Time-HiRes
	dev-perl/DateTime-Format-Strptime
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-HTTP
	media-gfx/imagemagick[perl]
	dev-perl/Log-Log4perl
	dev-perl/perl-ldap
	dev-perl/HTML-Highlight
	dev-perl/HTML-TagFilter
	dev-perl/HTML-Template
	dev-perl/HTML-Template-Expr
	dev-perl/Template-Toolkit
	dev-perl/XML-FeedPP
	dev-perl/JSON
	dev-perl/Config-JSON
	dev-perl/Text-CSV_XS
	dev-perl/Net-CIDR-Lite
	dev-perl/Finance-Quote
	dev-perl/POE
	dev-perl/POE-Component-IKC
	dev-perl/POE-Component-Client-HTTP
	dev-perl/URI
	dev-perl/Color-Calc
	dev-perl/Text-Aspell
	dev-perl/Class-InsideOut
	dev-perl/HTML-TagCloud
	dev-perl/Image-ExifTool
	dev-perl/Archive-Any
	dev-perl/Path-Class
	dev-perl/Exception-Class
	dev-perl/List-MoreUtils
	virtual/perl-File-Path
	dev-perl/Module-Find
	dev-perl/Class-C3
	dev-perl/Params-Validate
	dev-perl/Clone
	dev-perl/HTML-Packer
	dev-perl/JavaScript-Packer
	dev-perl/CSS-Packer
	dev-perl/Business-Tax-VAT-Validation
	dev-perl/Crypt-SSLeay
	dev-perl/Scope-Guard
	virtual/perl-Digest-SHA
	dev-perl/CSS-Minifier-XS
	dev-perl/JavaScript-Minifier-XS
	dev-perl/Readonly
	dev-perl/Business-PayPal-API
	dev-perl/Locales
	perl-core/Test-Harness"

#Compress::Zlib;Net::POP3 -why package in stable perl ???

S="${WORKDIR}/${MY_PN}"

need_apache2_2

src_install() {
	webapp_src_preinst
	dodir /var/log/
	touch  "${D}"/var/log/webgui.log
	fowners apache:apache "${D}"/var/log/webgui.log

	insinto "${D}/${PN}"
	doins -r "${S}"/etc/*

	doinitd "${FILESDIR}"/spectre
	dodoc  "${S}"/docs/*

	dodir "${D}/${MY_HTDOCSDIR}"/public
	cd  "${S}"/www

	cp -R . "${D}/${MY_HTDOCSDIR}"/public
	cd "${S}"
	cp -R lib sbin "${D}/${MY_HOSTROOTDIR}"

	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_src_install
}
