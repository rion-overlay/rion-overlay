# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

HOMEPAGE="http://delta.affinix.com/qca/"
LICENSE="LGPL-2"
KEYWORDS=""

DEPEND=">=dev-libs/pkcs11-helper-1.02"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}"/${P}-gcc44.patch )

inherit qca-plugin

DESCRIPTION="PKCS#11 (smartcard) plugin for QCA"
IUSE="${IUSE}"
