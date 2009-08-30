# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils webapp depend.apache

MY_PN="Xuheki"

DESCRIPTION="Xuheki is a fast web-based IMAP written in Perl"
HOMEPAGE="http://www.xuheki.com"
SRC_URI="http://www.xuheki.com/download/"${PV}"/"${MY_PN}"-"${PV}".tar.gz"
RESTRICT="mirror"

LICENSE="GPL-3"
KEYWORDS=""
IUSE="+mta +cron"

RDEPEND=""
DEPEND=">=virtual/mysql-5
		dev-lang/perl[ithreads]
		www-servers/apache
		www-apache/libapreq2
		www-apache/mod_perl
		mta? ( virtual/mta )
		cron? ( virtual/cron )
		dev-perl/Apache-Session-Wrapper
		dev-perl/DBIx-OO
		dev-perl/Net-IMAP-Client
		>=dev-perl/Crypt-Rijndael-1.07
		dev-perl/Regexp-Common-Email-Address
		dev-perl/Template-Toolkit[gd,mysql,xml]
		dev-perl/Template-Alloy
		dev-perl/libwww-perl[ssl]
		dev-perl/IO-Socket-SSL
		dev-perl/DateTime-Format-Mail
		dev-perl/Regexp-Common-Email-Address
		dev-perl/POE[libwww]
		>=dev-perl/Data-FormValidator-4.63
		dev-perl/Encode-Detect
		dev-perl/GD-SecurityImage
		dev-perl/Log-Log4perl
		dev-perl/Crypt-Rijndael
		dev-perl/Email-MIME-Encodings
		dev-perl/HTML-Format
		dev-perl/JSON
		dev-perl/JSON-XS
		dev-perl/MIME-tools
		dev-perl/MIME-Lite
		virtual/perl-Module-Load
		dev-perl/String-Random
		dev-perl/Text-Quoted
		perl-core/Time-HiRes
		virtual/perl-Time-Piece
		dev-perl/GD-SecurityImage"
#		dev-perl/Dynarch
#		dev-perl/XHK"

S="${WORKDIR}"/"${MY_PN}"-"${PV}"

need_apache2_2
need_httpd_fastcgi

src_install() {

	webapp_src_preinst
	# install web files
	  einfo "Installing web files"
	  cd "${S}"/docroot
	  cp -R . "${D}"/"${MY_HTDOCSDIR}"

	webapp_hook_script "${FILESDIR}"/reconfig-2
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en-2.txt
	webapp_postinst_txt ru "${FILESDIR}"/postinstall-ru-2.txt

	#install SQl script and create database
	webapp_sqlscript mysql "${FILESDIR}"/template.sql

	# install apache vhost.conf
	webapp_server_configfile apache "${S}"/templates/vhost.conf
	webapp_server_configfile apache "${S}"/perl/apache-startup.pl
	# end simple install, web part is installed


	# create requred dirs; start install script :)
	# Install server side files

	# create daemon data/work dirs.
	# and keep 
	dodir /var/lib/Xuheki/captcha-cache
	dodir /var/lib/Xuheki/sites-enabled
	dodir /var/lib/Xuheki/bin
	keepdir /var/lib/Xuheki/captcha-cache
	keepdir /var/lib/Xuheki/sites-enabled
	keepdir /var/lib/Xuheki/bin

	#install binares
	mv "${S}"/bin/*.pl "${D}"/var/lib/Xuheki/bin || die

	#create log dir
	dodir /var/log/Xuheki
	# and linking them
	dosym /var/log/Xuheki /var/lib/Xuheki/log

	# install templates file
	dodir /usr/share/"${P}"

	# more doint files

	# install cron script 
	if use cron ; then
		insinto /etc/cron.hourly
		newbin "${S}"/cron/clear-captcha-cache xuheki-clear-captcha
		keepdir /etc/cron.hourly
	fi



	# install init script and conf file
	newinitd "${FILESDIR}"/xuheki-"${PV}".init xuheki

	newconfd "${FILESDIR}"/xuheki.conf xuheki

	# install




	webapp_src_install
}



pkg_setup() {

webapp_pkg_setup

}

msg_1() {
		einfo "Xuheki can run under a certain URL so there's no need to dedicate the"
		einfo "to it, but we still need to know the domain name."
		ebeep 5
		epause 5
}
