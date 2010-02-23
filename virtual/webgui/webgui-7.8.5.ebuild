# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="All depend for Web-Gui CMS"
SRC_URI=""

SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND="${DEPEND}"
DEPEND="<dev-lang/perl-5.10
		www-servers/apache:2[-threads]
		>=dev-perl/libwww-perl-5.831
		dev-perl/Test-MockObject
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		>=dev-perl/Test-Class-0.31
		>=dev-perl/Pod-Coverage-0.19
		>=perl-core/Text-Balanced-2.0
		>=virtual/perl-Text-Balanced-2.0
		>=perl-core/Digest-MD5-2.38
		>=virtual/perl-Digest-MD5-2.38
		dev-perl/DBI
		>=dev-perl/DBD-mysql-4.01.2
		>=perl-core/Archive-Tar-1.44
		>=virtual/perl-Archive-Tar-1.44
		>=dev-perl/Archive-Zip-1.26
		>=perl-core/IO-Zlib-1.09
		>=virtual/perl-IO-Zlib-1.09
		perl-core/libnet
		>=dev-perl/MIME-tools-5.427
		>=dev-perl/Tie-IxHash-1.21
		dev-perl/Tie-CPHash
		>=dev-perl/XML-Simple-2.18
		dev-perl/DateTime
		>=perl-core/Time-HiRes-1.97.19
		>=virtual/perl-Time-HiRes-1.97.19
		dev-perl/DateTime-Format-Strptime
		>=dev-perl/DateTime-Format-Mail-0.3001
		=media-gfx/imagemagick-6*[perl]
		dev-perl/Log-Log4perl
		dev-perl/perl-ldap
		dev-perl/HTML-Highlight
		dev-perl/HTML-TagFilter
		dev-perl/HTML-Template
		dev-perl/HTML-Template-Expr
		dev-perl/Template-Toolkit[gd,mysql]
		dev-perl/XML-FeedPP
		dev-perl/JSON
		dev-perl/Config-JSON
		dev-perl/Text-CSV_XS
		>=dev-perl/Net-CIDR-Lite-0.20
		dev-perl/Finance-Quote
		>=dev-perl/POE-1.15
		dev-perl/POE-Component-IKC
		dev-perl/POE-Component-Client-HTTP
		www-apache/libapreq2:2
		www-apache/mod_perl
		dev-perl/URI
		dev-perl/Color-Calc
		dev-perl/Text-Aspell
		dev-perl/Weather-Com
		dev-perl/Class-InsideOut
		dev-perl/HTML-TagCloud
		dev-perl/Image-ExifTool
		dev-perl/Archive-Any
		dev-perl/Path-Class
		>=dev-perl/Exception-Class-1.26
		>=dev-perl/List-MoreUtils-0.22
		>=perl-core/File-Path-2.07
		>=virtual/perl-File-Path-2.07
		dev-perl/Module-Find
		dev-perl/Class-C3
		>=dev-perl/Params-Validate-0.91
		>=dev-perl/Clone-0.31
		dev-perl/HTML-Packer
		dev-perl/JavaScript-Packer
		dev-perl/CSS-Packer
		dev-perl/Business-Tax-VAT-Validation
		dev-perl/Crypt-SSLeay
		dev-perl/Scope-Guard
		>=virtual/perl-Digest-SHA-5.47
		dev-perl/CSS-Minifier-XS
		dev-perl/JavaScript-Minifier-XS
		dev-perl/Readonly
		dev-perl/Business-PayPal-API
		>=dev-perl/Locales-0.10"
