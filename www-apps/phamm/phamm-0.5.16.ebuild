# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# 
# bugs #128106 (bugs.gentoo.org) :)
# rion overlay

EAPI=2

inherit webapp depend.php

DESCRIPTION="LDAP web front-end written on PHP"
HOMEPAGE="http://www.phamm.org/"

SRC_URI="http://open.rhx.it/phamm/${P}.tar.gz
		!minimal? (
isp-schema?	( http://open.rhx.it/phamm/schema/ISPEnv2.schema -> ISPEnv2-phamm.schema )
amavis-schema? ( http://open.rhx.it/phamm/schema/amavis.schema -> amavis-phamm.schema )
dns-schema? ( http://open.rhx.it/phamm/schema/dnsdomain2.schema -> dnsdomain2-phamm.schema )
ftp-schema? ( http://open.rhx.it/phamm/schema/pureftpd.schema -> pureftpd-phamm.schema )
radius? ( http://open.rhx.it/phamm/schema/radius.schema -> radius-phamm.schema )
samba? ( http://open.rhx.it/phamm/schema/samba.schema -> samba-phamm.schema ) )"

LICENSE="GPL-2
		isp-schema? ( as-is )
		amavis-schema? ( FDL-1.2 )
		dns-schema? ( as-is )
		ftp-schema? ( BSD )
		radius? ( as-is )
		samba? ( GPL-3 )"
KEYWORDS="~x86 ~amd64"
IUSE="+minimal isp-schema amavis-schema dns-schema ftp-schema radius samba"
DEPEND=""

RDEPEND="virtual/mta"

pkg_setup() {
	webapp_pkg_setup
	require_php_with_use ldap xml
}

src_unpack() {
if use minimal && \
( use isp-schema  ||  use amavis-schema  ||  use dns-schema  || use samba || use ftp-schema || use radius ) ; then

								eerror "USE flag set invalid"
								eerror "USE flag USE=\"minimal\"  not allowed "
								eerror  "and other USE flags combinations "
								eerror " Please, disable USE=\"minimal\" or "
								eerror "disable other USE flag "
fi

unpack "${P}.tar.gz"

if use !minimal;then
		if use isp-schema ;then
				cp "${DESTDIR}/ISPEnv2-phamm.schema" "${T}" || die
		fi
		if use amavis-schema ;then
				cp "${DESTDIR}/amavis-phamm.schema"  "${T}" || die
		fi
		if use dns-schema; then
				cp "${DESTDIR}/dnsdomain2-phamm.schema"  "${T}" || die
		fi
		if use ftp-schema ; then
		        cp "${DESTDIR}/pureftpd-phamm.schema"  "${T}" || die
		fi
		if use radius ; then
		        cp "${DESTDIR}/radius-phamm.schema"  "${T}" || die
		fi
		if use samba ; then
				cp "${DESTDIR}/samba-phamm.schema"  "${T}" || die
		fi
		einfo " file copy"
fi

}
src_install() {
webapp_src_preinst

	dodoc CHANGELOG COPYRIGHT INSTALL LIB_FUNCTIONS
	dodoc PHAMM-LOGO-USE.POLICY README
	dodoc README.locales THANKS TODO

	mv "${S}/examples" "${D}/usr/share/doc/${PF}/"
	mv "${S}/schema" "${D}/usr/share/doc/${PF}/"
	mv "${S}/docs" "${D}/usr/share/doc/${PF}"
	if use !minimal;then
	cp "${DISTDIR}"/"*-phamm.schema" "${D}/usr/share/doc/${PF}/schema/" || die
	fi
	cp -r . "${D}${MY_HTDOCSDIR}" || die
	cd "${D}${MY_HTDOCSDIR}"

	webapp_configfile ${MY_HTDOCSDIR}/config.inc.php
	for each in plugins/*; do
		webapp_configfile ${MY_HTDOCSDIR}/${each} || die
	done

	webapp_src_install
}
