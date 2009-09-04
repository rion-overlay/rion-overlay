# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


EAPI="2"

inherit eutils ssl-cert toolchain-funcs

DESCRIPTION="Robust, small and high performance http and reverse proxy server"

HOMEPAGE="http://sysoev.ru/nginx/" # Именно =:)
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="+aio debug perftool addition debug geoip fastcgi flv mail  ipv6 \
		image-resize pcre cpp perl +rt-signal random-index \
		securelink ssl status sub webdav xslt zlib"

DEPEND="dev-lang/perl
	geoip? ( dev-libs/geoip )
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	perftool? ( dev-libs/google-perftools )
	xslt? (
			dev-libs/libxslt
			dev-libs/libxml2 )
	image-resize? ( media-libs/gd )
	zlib? ( sys-libs/zlib )"

RDEPEND="${DEPEND}"

pkg_setup() {
	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}
}

src_unpack() {
	default
}
src_prepare() {
	
	sed -i 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make || die
}

src_configure() {
	local myconf=""
#	if use kernel_linux ; then

		use rt-signal 	&& myconf="${myconf} --with-rtsig_module "
		use aio			&& myconf="${myconf} --with-file-aio "
#	else
#		eerror "Your platform not supported rt_signal() syscall"
#	fi
	
	use cpp 		&& myconf="${myconf} --with-cpp_test_module"
	use perftool	&& myconf="${myconf}  --with-google_perftools_module"
	use xslt		 && myconf="${myconf}  --with-http_xslt_module"
	use image-resize  && myconf="${myconf}  --with-http_image_filter_module"
	use geoip		&& myconf="${myconf}  --with-http_geoip_module "
	use ssl     	&& myconf="${myconf} --with-http_ssl_module"
	use addition && myconf="${myconf} --with-http_addition_module"
	use ipv6	&& myconf="${myconf} --with-ipv6"
	use fastcgi	|| myconf="${myconf} --without-http_fastcgi_module"
	use fastcgi	&& myconf="${myconf} --with-http_realip_module"
	use flv		&& myconf="${myconf} --with-http_flv_module"
	use zlib	|| myconf="${myconf} --without-http_gzip_module"
	use pcre	|| {
		myconf="${myconf} --without-pcre --without-http_rewrite_module"
	}
	use debug	&& myconf="${myconf} --with-debug"
	use mail	&& myconf="${myconf} --with-mail" # pop3/imap4/smtp  proxy support
	if use mail && use ssl; then
		 myconf="${myconf} --with-mail_ssl_module"
	fi
	use perl	&& myconf="${myconf} --with-http_perl_module"
	use status	&& myconf="${myconf} --with-http_stub_status_module"
	use webdav	&& myconf="${myconf} --with-http_dav_module"
	use sub		&& myconf="${myconf} --with-http_sub_module"
	use random-index	&& myconf="${myconf} --with-http_random_index_module"
	use securelink && myconf="${myconf} --with-http_secure_link_module"
	use debug		&& myconf="${myconf} --with-debug"
	tc-export CC
	./configure \
		--prefix=/usr \
		--conf-path=/etc/${PN}/${PN}.conf \
		--http-log-path=/var/log/${PN}/access_log \
		--error-log-path=/var/log/${PN}/error_log \
		--pid-path=/var/run/${PN}.pid \
		--http-client-body-temp-path=/var/tmp/${PN}/client \
		--http-proxy-temp-path=/var/tmp/${PN}/proxy \
		--http-fastcgi-temp-path=/var/tmp/${PN}/fastcgi \
		--with-md5-asm --with-md5=/usr/include \
		--with-sha1-asm --with-sha1=/usr/include \
		${myconf} || die "configure failed"
}
src_compile() {
	tc-export CC

	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "failed to compile"
}

src_install() {
	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi}

	dosbin objs/nginx
	cp "${FILESDIR}"/nginx-r1 "${T}"/nginx
	doinitd "${T}"/nginx

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins conf/*

	dodoc CHANGES{,.ru} README

	use perl && {
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}"|| die "failed to install perl stuff"
	}
}

pkg_postinst() {
	use ssl && {
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	}
}
