# Distributed under the terms of the GNU General Public License v2
# $Header$
#
# Author: Andrei Vinogradov aka slepnoga <spamslepnoga@inbox.ru>
# based on perl-modules.eclass code

# @ECLASS: openca-perl.eclass
# @MAINTAINER:Andrei Vinogradov (spamslepnoga@inbox.ru)
# @BLURB: eclass for CPAN OpenCA perl modules
# @DESCRIPTION:
# This eclass provide fast and easier installation of perl
# modules requred  in OpenCA packages.It set ${S}
# OpenCA modules included in openca tarball only


inherit perl-module

DEPEND="sys-apps/sed
		${DEPEND}"
DESCRIPTION="Based on the $ECLASS  eclass"
HOMEPAGE="http://www.openca.org/"
SLOT=0

# @FUNCTION: openca-perl_set_s
# @DESCRIPTION:
# Call this function if you have set custom ${S} variable
# to buld embeded OpenCA modules


openca-perl_set_s() {
		local base_dir="${A}/src/modules/${PN}"
		local SSS=""
		SSS=`echo "${base_dir}" | tr "[:upper:]" "[:lower:]"`
		S="${WORKDIR}"/"${SSS}"
		set "${S}"
}

