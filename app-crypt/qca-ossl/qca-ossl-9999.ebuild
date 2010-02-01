# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:/var/cvsroot/gentoo-x86/app-crypt/qca-ossl/qca-ossl-9999.ebuild,v1.0 2008/03/26 11:32:19 rion Exp $

EAPI="2"

HOMEPAGE="http://delta.affinix.com/qca/"
LICENSE="LGPL-2"
KEYWORDS=""

DEPEND=">=dev-libs/openssl-0.9.6"
RDEPEND="${DEPEND}"

inherit qca-plugin

DESCRIPTION="TLS, S/MIME, PKCS#12, crypto algorithms plugin for QCA"
IUSE="${IUSE}"
