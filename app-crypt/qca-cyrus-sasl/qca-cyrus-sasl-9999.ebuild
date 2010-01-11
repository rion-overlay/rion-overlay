# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:/var/cvsroot/gentoo-x86/app-crypt/qca-cyrus-sasl/qca-cyrus-sasl-9999.ebuild,v1.0 2008/03/26 11:32:19 rion Exp $

HOMEPAGE="http://delta.affinix.com/qca/"

LICENSE="LGPL-2"

KEYWORDS=""

DEPEND="dev-libs/cyrus-sasl"
RDEPEND="${DEPEND}"

inherit qca-plugin

DESCRIPTION="SASL plugin for QCA"
IUSE="${IUSE}"
