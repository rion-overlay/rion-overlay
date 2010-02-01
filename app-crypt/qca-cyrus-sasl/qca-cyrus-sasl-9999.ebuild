# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

HOMEPAGE="http://delta.affinix.com/qca/"
LICENSE="LGPL-2"
KEYWORDS=""

DEPEND="dev-libs/cyrus-sasl"
RDEPEND="${DEPEND}"

inherit qca-plugin

DESCRIPTION="SASL plugin for QCA"
IUSE="${IUSE}"
