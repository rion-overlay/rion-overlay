# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: pki-dogtag.eclass 
# @MAINTAINER:
# A. Vinogradov <spamslepnoga@inbox.ru>
# @BLURB: This eclass provides functions for Dog Tag CA and Fedora PKI packages
# @DESCRIPTION:
# This eclass provides functions for Dog Tag CA and Fedora PKI packages
# Original Author: A. Vinogradov <spamslepnoga@inbox.ru>
# Purpose: 
#



# @ECLASS-VARIABLE: EAPI
# @DESCRIPTION:
# By default this eclasses want EAPI 2 which might be redefinable to newer
# versions.
case ${EAPI:-0} in
	        2) : ;;
			*) DEPEND="EAPI-TOO-OLD" ;;
esac

# @ECLASS-VARIABLE: LICENSE
# @DESCRIPTION:
# If not define, use default GPL-2-with-exceptions license
LICENSE="${LICENSE:-|| ( GPL-2-with-exceptions license )}"


# @ECLASS-VARIABLE: HOMEPAGE
# @DESCRIPTION:
[[ -z "${HOMEPAGE}" ]] && \
		HOMEPAGE="http://pki.fedoraproject.org/wiki/PKI_Main_Page"

# @ECLASS-VARIABLE: RPM_REV
# @DESCRIPTION:
# revision rpm files ,default - empty;
# Format: defis plus revision, i.e "-1"
[[ -z "${RPM_REV}" ]] && \
	RPM_REV=""

# @ECLASS-VARIABLE: FC_DIST
# @DESCRIPTION:
# Fedora dist. number ;
# i.e if FC dist 11 and rpm name
# include fc11, set this "fc11"
# At this moment use fc11
# TODO :) EPEL,RHEL rpm support

[[ -z "${FC_DIST}" ]] && \
	FC_DIST="fc11"

# @ECLASS-VARIABLE: SRC_URI
# @DESCRIPTION:
# set SRC_URI
# if source in src.rpm format, inherit rpm eclass

[[ -z "${SRC_URI}" ]] && \
SRC_URI="http://pki.fedoraproject.org/pki/download/pki/${PV}/${FC_DIST}/SRPMS/${P}${RPM_REV}.${FC_DIST}.src.rpm" \
	&& inherit rpm

# @DESCRIPTION:
# Define Slot
# At this moment only SLOT=0
# is supported
SLOT="0"

