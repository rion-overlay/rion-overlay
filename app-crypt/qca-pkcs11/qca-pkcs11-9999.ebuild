# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:/var/cvsroot/gentoo-x86/app-crypt/qca-pkcs11/qca-pkcs11-9999.ebuild,v1.0 2008/03/26 11:32:19 rion Exp $

HOMEPAGE="http://delta.affinix.com/qca/"

LICENSE="LGPL-2"

KEYWORDS=""

DEPEND=">=dev-libs/pkcs11-helper-1.02"
RDEPEND="${DEPEND}"

inherit qca-plugin

DESCRIPTION="PKCS#11 (smartcard) plugin for QCA"
IUSE="${IUSE}"
