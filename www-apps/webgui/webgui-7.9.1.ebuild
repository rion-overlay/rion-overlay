# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_PN="WebGUI" # tarboll name
REL="beta" #stable or beta

inherit  depend.apache webapp eutils

DESCRIPTION="CMS in Perl"
HOMEPAGE="http://www.webgui.org/"
SRC_URI="http://update.webgui.org/7.x.x/${P}-${REL}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.8-r5"

RDEPEND=">=dev-lang/perl-5.8.8-r5
	www-apache/mod_perl
	>=dev-perl/libwww-perl-5.833
	>=virtual/perl-Test-Simple-0.92
	>=dev-perl/Test-MockObject-1.02
	>=dev-perl/Test-Deep-0.095
	>=dev-perl/Test-Exception-0.27
	>=dev-perl/Test-Class-0.31
	>=dev-perl/Pod-Coverage-0.19
	>=virtual/perl-Text-Balanced-2.00
	>=virtual/perl-Digest-MD5-2.38
	>=dev-perl/DBI-1.607
	>=dev-perl/DBD-mysql-4.010
	>=dev-perl/HTML-Parser-3.60
	>=virtual/perl-Archive-Tar-1.44
	>=dev-perl/Archive-Zip-1.26
	>=virtual/perl-IO-Zlib-1.09
	>=dev-perl/Net-SMTP-SSL-1.01
	>=dev-perl/MIME-tools-5.427
	>=dev-perl/Tie-IxHash-1.21
	>=dev-perl/Tie-CPHash-1.04
	>=dev-perl/XML-Simple-2.18
	>=dev-perl/DateTime-0.45
	>=virtual/perl-Time-HiRes-1.97.19
	>=dev-perl/DateTime-Format-Strptime-1.0800
	>=dev-perl/DateTime-Format-Mail-0.3001
	>=dev-perl/DateTime-Format-HTTP-0.38
	=media-gfx/imagemagick-6*[perl,jpeg,png,svg]
	>=dev-perl/Log-Log4perl-1.20
	>=dev-perl/perl-ldap-0.39
	>=dev-perl/HTML-Highlight-0.20
	>=dev-perl/HTML-TagFilter-1.03
	>=dev-perl/HTML-Template-2.9
	>=dev-perl/HTML-Template-Expr-0.07
	>=dev-perl/Template-Toolkit-2.20
	>=dev-perl/XML-FeedPP-0.40
	>=dev-perl/JSON-2.12
	>=dev-perl/Config-JSON-1.3.1
	>=dev-perl/Text-CSV_XS-0.64
	>=dev-perl/Net-CIDR-Lite-0.20
	>=dev-perl/Finance-Quote-1.15
	>=dev-perl/POE-1.005
	>=dev-perl/POE-Component-IKC-0.2001
	>=dev-perl/POE-Component-Client-HTTP-0.88
	>=www-apache/libapreq2-2.08[perl]
	>=dev-perl/URI-1.53
	>=dev-perl/Color-Calc-1.0
	>=dev-perl/Text-Aspell-0.01
	>=dev-perl/Weather-Com-0.5.3
	>=dev-perl/Class-InsideOut-1.09
	>=dev-perl/HTML-TagCloud-0.34
	>=media-libs/exiftool-7.67
	>=dev-perl/Archive-Any-0.0932
	>=dev-perl/Path-Class-0.16
	>=dev-perl/Exception-Class-1.26
	>=dev-perl/List-MoreUtils-0.22
	>=virtual/perl-File-Path-2.07
	>=dev-perl/Module-Find-0.06
	>=dev-perl/Class-C3-0.21
	>=dev-perl/Params-Validate-0.91
	>=dev-perl/Clone-0.31
	>=dev-perl/HTML-Packer-0.4
	>=dev-perl/JavaScript-Packer-0.04
	>=dev-perl/CSS-Packer-0.2
	>=dev-perl/Business-Tax-VAT-Validation-0.20
	>=dev-perl/Crypt-SSLeay-0.57
	>=dev-perl/Scope-Guard-0.03
	>=virtual/perl-Digest-SHA-5.47
	>=dev-perl/CSS-Minifier-XS-0.03
	>=dev-perl/JavaScript-Minifier-XS-0.05
	>=dev-perl/Readonly-1.03
	>=dev-perl/Business-PayPal-API-0.62
	>=dev-perl/Locales-0.10
	>=perl-core/Test-Harness-3.17
	virtual/perl-libnet"

S="${WORKDIR}/${MY_PN}"

need_apache2_2

src_install() {
	webapp_src_preinst

	dodir /var/log/
	touch  "${D}"/var/log/webgui.log || die
	fowners apache:apache /var/log/webgui.log || die

	insinto /etc/"${PN}" || die
	doins -r "${S}"/etc/* ||die

	doinitd "${FILESDIR}"/spectre || die

	insinto  "${MY_HTDOCSDIR}/"public || die
	doins -r www/*   || die

	insinto  "${MY_HTDOCSDIR}"
	doins -r lib || die
	doins -r sbin || die

#	webapp_configfile
	webapp_hook_script "${FILESDIR}"/reconfig
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_postinst_txt ru "${FILESDIR}"/postinstall-ru.txt
#webapp_serverowned

	dodoc  "${S}"/docs/*
	webapp_src_install
}

src_test() {

	cd "${S}"/sbin
	/usr/bin/perl testEnvironment.pl --simpleReport > "${T}"/t

	if ! grep -q "Testing complete!" "${T}"/t; then
		ewarn "Missing Perl dependency!"
		ewarn ""

		cat "${T}"/t

		ewarn ""
		ewarn "Please send bug in mantainer"
		die "Missing dependencies."
	fi
}
