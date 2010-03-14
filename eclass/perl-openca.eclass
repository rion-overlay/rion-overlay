# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$
#
# Author: Andrei Vinogradov <spamslepnoga@inbox.ru>
# based on perl-modules.eclass code

# @ECLASS: openca-perl.eclass
# @MAINTAINER:Andrei Vinogradov (spamslepnoga@inbox.ru)
# @BLURB: eclass for CPAN OpenCA perl modules
# @DESCRIPTION:
# This eclass provide fast and easier installation of perl
# modules reqered  in OpenCA packages.
# Only for CPAN modules, if you have internal OpenCA modules
# included in openca tarball , use openca-perl eclass

inherit perl-module


EXPORT_FUNCTIONS src_unpack

DEPEND="sys-apps/sed
		${DEPEND}"

RDEPEND="${DEPEND}"

# Commented due gentoo developers request
#DESCRIPTION="Based on the $ECLASS  eclass"
SRC_URI="mirror://sourceforge/openca/openca-base-${PV}.tar.gz"

HOMEPAGE="http://www.openca.org/"
LICENSE="${LICENSE:-|| ( Artistic GPL-2 )}"


SLOT="0"

# @FUNCTION: openca-perl_src_unpack
# @DESCRIPTION:
# Call perl-module_src_unpack and delete stub prova.pl file


perl-openca_src_unpack() {
perl-module_src_unpack

sed -i -e /prova.pl/d "${S}"/MANIFEST ||die "sed failed"

einfo "editing MANIFEST"

rm -r "${S}"/prova.pl || die "Not removed prova.pl"

einfo "removed prova.pl"
}

