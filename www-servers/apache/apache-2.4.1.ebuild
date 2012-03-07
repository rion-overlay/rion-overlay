# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# latest gentoo apache files
GENTOO_PATCHSTAMP="20120213"
GENTOO_DEVELOPER="jmbsvicetto"
GENTOO_PATCHNAME="gentoo-apache-2.2.21-r2"

# IUSE/USE_EXPAND magic
IUSE_MPMS_FORK="peruser prefork"
IUSE_MPMS_THREAD="event worker"

IUSE_MODULES="access_compat action alias allowmethods asis auth_basic
auth_digest auth_form auth_anon auth_core auth_dbd auth_dbm auth_file authz_ldap
authz_core authz_dbd authz_dbm authz_groupfile authz_host authz_owner authz_user
autoindex buffer cache cache_disk cern_meta cgi cgid charset_lite data dav
dav_fs dav_lock dbd deflate dialup dir dumpio echo env example expires
ext_filter file_cache filter header hearbeat heartmonitor ident imagemap include
info lbmethod_bybusyness lbmethod_byrequests lbmethod_bytraffic
lbmethod_heartbeat ldap log_config log_debug log_forensis logio lua mime
mime_magic negotiation proxy proxy_ajp proxy_balancer proxy_connect
proxy_express proxy_fdpass proxy_ftp proxy_html proxy_http proxy_scgi ratelimit
reflector remoteip reqtimeout request rewrite sed session session_cookie
session_crypto session_dbd setenvif slotmem_plain slotmem_shm socache_dbm
socache_dc socache_memcache socache_shmcb speling ssl status substitute suexec
unique_id unixd userdir usertrack version vhost_alias watchdog xml2enc"
# The following are also in the source as of this version, but are not available
# for user selection:
# bucketeer case_filter case_filter_in echo http isapi optional_fn_export
# optional_fn_import optional_hook_export optional_hook_import

# inter-module dependencies
# TODO: this may still be incomplete
MODULE_DEPENDS="
	dav_fs:dav
	dav_lock:dav
	deflate:filter
	disk_cache:cache
	ext_filter:filter
	file_cache:cache
	log_forensic:log_config
	logio:log_config
	mem_cache:cache
	mime_magic:mime
	proxy_ajp:proxy
	proxy_balancer:proxy
	proxy_connect:proxy
	proxy_ftp:proxy
	proxy_http:proxy
	proxy_scgi:proxy
	proxy_express:proxy
	proxy_fdpass_module
	substitute:filter
"

# module<->define mappings
MODULE_DEFINES="
	auth_digest:AUTH_DIGEST
	authnz_ldap:AUTHNZ_LDAP
	cache:CACHE
	dav:DAV
	dav_fs:DAV
	dav_lock:DAV
	cache_disk:CACHE
	file_cache:CACHE
	info:INFO
	ldap:LDAP
	mem_cache:CACHE
	proxy:PROXY
	proxy_ajp:PROXY
	proxy_balancer:PROXY
	proxy_connect:PROXY
	proxy_ftp:PROXY
	proxy_http:PROXY
	proxy_express:PROXY
	proxy_fdpass:PROXY
	proxy_html:PROXY
	proxy_scgi:PROXY
	ssl:SSL
	status:STATUS
	suexec:SUEXEC
	userdir:USERDIR
"

# critical modules for the default config
MODULE_CRITICAL="
	authz_host
	dir
	mime
	unixd
"

inherit apache-24

DESCRIPTION="The Apache Web Server."
HOMEPAGE="http://httpd.apache.org/"

# some helper scripts are Apache-1.1, thus both are here
LICENSE="Apache-2.0 Apache-1.1"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="
	apache2_modules_lua? ( =dev-lang/lua-5.1* )
	apache2_modules_xml2enc? ( dev-libs/libxml2 )
	apache2_modules_session_crypto? ( || (  >=dev-libs/apr-util-1.4.1[nss]
									>=dev-libs/apr-util-1.4.1[openssl] ) )"

DEPEND="${DEPEND}
		${CEPEND}	
	>=dev-libs/openssl-1.0
	apache2_modules_deflate? ( sys-libs/zlib )
	>=dev-libs/libpcre-8.0"

# dependency on >=dev-libs/apr-1.4.5 for bug #368651
RDEPEND="${RDEPEND}
		 ${CEPEND}
	!app-admin/apache-tools
	>=dev-libs/apr-1.4.6
	>=dev-libs/openssl-1.0
	apache2_modules_mime? ( app-misc/mime-types )"
