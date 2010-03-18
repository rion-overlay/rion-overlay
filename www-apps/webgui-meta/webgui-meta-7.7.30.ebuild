# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Meta package for all perl depend for Web-Gui CMS"
HOMEPAGE="http://slepnoga.googlecode.com"
SRC_URI=""

SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"

IUSE=""
DEPEND=""
RDEPEND=">=dev-lang/perl-5.8.8-r5
		>=dev-perl/Template-Toolkit-2.20[gd,mysql,xml]
		perl-core/Module-Load
		>=dev-perl/libwww-perl-5.833
		>=virtual/perl-Test-Harness-2.64
		>=dev-perl/Test-MockObject-1.02
		>=dev-perl/Test-Deep-0.106
		>=dev-perl/Test-Exception-0.27
		>=dev-perl/Test-Class-0.31
		>=dev-perl/Pod-Coverage-0.19
		>=perl-core/Text-Balanced-2.0.2
		>=virtual/perl-Digest-MD5-2.38
		>=dev-perl/DBI-1.607
		>=dev-perl/DBD-mysql-4.01.0
		>=dev-perl/HTML-Parser-3.60
		>=virtual/perl-Archive-Tar-1.44
		>=dev-perl/Archive-Zip-1.26
		>=virtual/perl-IO-Zlib-1.09
		>=dev-perl/MIME-tools-5.427
		dev-perl/Tie-IxHash
		dev-perl/Tie-CPHash
		dev-perl/XML-Simple
		>=virtual/perl-Time-HiRes-1.97.19
		dev-perl/DateTime-Format-Strptime
		>=dev-perl/DateTime-Format-Mail-0.3001
		=media-gfx/imagemagick-6*[perl]
		dev-perl/Log-Log4perl
		>=dev-perl/perl-ldap-0.39
		dev-perl/HTML-Highlight
		dev-perl/HTML-TagFilter
		dev-perl/HTML-Template
		dev-perl/HTML-Template-Expr
		>=dev-perl/XML-FeedPP-0.40
		dev-perl/JSON
		dev-perl/Config-JSON
		dev-perl/Text-CSV_XS
		dev-perl/Net-Subnets
		dev-perl/Finance-Quote
		>=dev-perl/POE-1.005
		>=dev-perl/POE-Component-IKC-0.2001
		dev-perl/POE-Component-Client-HTTP
		www-apache/libapreq2:2
		www-apache/mod_perl
		dev-perl/URI
		virtual/perl-Scalar-List-Utils
		dev-perl/Color-Calc
		dev-perl/Text-Aspell
		dev-perl/Weather-Com
		dev-perl/Path-Class
		>=dev-perl/Exception-Class-1.29
		>=dev-perl/List-MoreUtils-0.22
		dev-perl/HTML-TagCloud
		dev-perl/Image-ExifTool
		dev-perl/Archive-Any
		>=virtual/perl-File-Path-2.08
		dev-perl/Module-Find
		>=dev-perl/Class-C3-0.21
		>=dev-perl/Params-Validate-0.92
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
		dev-perl/Net-CIDR-Lite"
