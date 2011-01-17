# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Popishu, the text editor with IDE features for LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}
	>=x11-libs/qscintilla-2.4.3"
RDEPEND="${DEPEND}"
