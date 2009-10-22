# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/qca-gnupg/qca-gnupg-9999.ebuild,v1.0 2008/03/26 11:32:19 rion Exp $

HOMEPAGE="http://delta.affinix.com/qca/"

LICENSE="GPL-2"

KEYWORDS=""

RDEPEND="app-crypt/gnupg"

inherit qca-plugin

DESCRIPTION="GnuPG plugin for QCA"
IUSE="${IUSE}"
