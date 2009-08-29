# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A squid redirector used for blocking unwanted content"
HOMEPAGE="http://rejik.ru/"
SRC_URI="http://rejik.ru/download/redirector-${PV}.tgz
	http://rejik.ru/download/banlists-2.x.x.tgz
	http://rejik.ru/download/dbl-2.0.tgz
	http://rejik.ru/download/squid-like-www-en.tgz
	http://rejik.ru/download/squid-like-www-ru.tgz"
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+banlis +dbl"
# TODO errorwww
DEPEND="dev-libs/libpcre:3"
RDEPEND="net-proxy/squid
	net-misc/wget
	dev-perl/Text-Iconv
	dev-perl/XML-Parser"

SQUID_USER="squid"
SQUID_GROUP="squid"
S=${WORKDIR}/redirector-${PV}
INSTALLDIR="/opt/rejik"
LOGDIR="/var/log/rejik"
HTTPBAN="http\://domain.tld/"

src_prepare() {
cd "${S}"
sed -i -e "s:INSTALL_PATH=/usr/local/rejik3:INSTALL_PATH=${INSTALLDIR}:g" "Makefile"
sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" "vars.h"
sed -i -e "s:SQUID_USER=nobody:SQUID_USER=${SQUID_USER}:g" "Makefile"
sed -i -e "s:SQUID_GROUP=nogroup:SQUID_GROUP=${SQUID_GROUP}:g" "Makefile"
sed -i -e "s:error_log /usr/local/rejik3:error_log ${LOGDIR}:g" "redirector.conf.dist"
sed -i -e "s:change_log /usr/local/rejik3:change_log ${LOGDIR}:g" \
																"redirector.conf.dist"

sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" "redirector.conf.dist"
sed -i -e "s:url http\://127.0.0.1/ban:url ${HTTPBAN}:g" "redirector.conf.dist"

if use dbl; then
sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" ${WORKDIR}"/dbl/Update.Fast"
#      sed -i -e "s:/usr/bin/wget:/usr/bin/wget:g" ${WORKDIR}/dbl/Update.Fast
sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" ${WORKDIR}"/dbl/Update"
#      sed -i -e "s:/usr/bin/wget:/usr/bin/wget:g" ${WORKDIR}/dbl/Update
sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" ${WORKDIR}"/dbl/FULL"
sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" ${WORKDIR}"/dbl/FAST"
sed -i -e "s:/usr/local/rejik3:${INSTALLDIR}:g" ${WORKDIR}"/dbl/dbl_expand"
fi
}

src_install() {
dodir ${INSTALLDIR}
cp "make-cache" "${D}${INSTALLDIR}"
cp "redirector" "${D}${INSTALLDIR}"
cp "redirector.conf.dist" "${D}${INSTALLDIR}"

dodir ${INSTALLDIR}/tools
cp "${S}/tools/kill-cache" "${D}${INSTALLDIR}/tools"
cp "${S}/tools/benchmark" "${D}${INSTALLDIR}/tools"
cp "${S}/tools/IN.gz" "${D}${INSTALLDIR}/tools"
cp "${FILESDIR}/check-redirector" "${D}${INSTALLDIR}/tools"
cp "${FILESDIR}/set-permissions" "${D}${INSTALLDIR}/tools"

dodir ${LOGDIR}

fowners -R ${SQUID_USER}:${SQUID_GROUP} ${INSTALLDIR}
fowners -R ${SQUID_USER}:${SQUID_GROUP} ${LOGDIR}
fperms 770 ${INSTALLDIR}
fperms 644 ${INSTALLDIR}/redirector.conf.dist
fperms 755 ${INSTALLDIR}/redirector
fperms 755 ${INSTALLDIR}/make-cache
fperms 755 ${INSTALLDIR}/tools/set-permissions
fperms 755 ${INSTALLDIR}/tools/kill-cache
fperms 755 ${INSTALLDIR}/tools/benchmark
fperms 644 ${INSTALLDIR}/tools/IN.gz

if use banlist; then
dodir ${INSTALLDIR}/banlists
cp -R "${WORKDIR}/banlists" "${D}${INSTALLDIR}"
fowners -R ${SQUID_USER}:${SQUID_GROUP} ${INSTALLDIR}/banlists
fperms 775 ${INSTALLDIR}/banlists
fperms 775 ${INSTALLDIR}/banlists/porno
fperms 775 ${INSTALLDIR}/banlists/js
fperms 775 ${INSTALLDIR}/banlists/mp3
fperms 775 ${INSTALLDIR}/banlists/banners
fi

#if use errorwww; then
#TODO
#echo "errorwww not complited"
#fi

if use dbl; then
dodir ${INSTALLDIR}/dbl
cp -R "${WORKDIR}/dbl" "${D}${INSTALLDIR}"
fowners -R ${SQUID_USER}:${SQUID_GROUP} ${INSTALLDIR}/dbl
fi
}

pkg_postinst() {
einfo ""
einfo "Make sure that squid runs under user squid"
einfo "and group squid. If not, redefine SQUID_USER"
einfo "and SQUID_GROUP in ebuild. Or change owner of ${INSTALLDIR} manually"
einfo ""
einfo "Copy ${INSTALLDIR}/redirector.conf.dist to ${INSTALLDIR}/redirector.conf and add line"
einfo "for squid 3.*"
einfo "url_rewrite_program ${INSTALLDIR}/redirector ${INSTALLDIR}/redirector.conf "
einfo "for squid 2.*"
einfo "redirect_program ${INSTALLDIR}/redirector ${INSTALLDIR}/redirector.conf"
einfo "to /etc/squid/squid.conf"
einfo ""
einfo "Dont forget to edit ${INSTALLDIR}/redirector.conf"
einfo "Be sure redirector.conf have right permissions"
}
