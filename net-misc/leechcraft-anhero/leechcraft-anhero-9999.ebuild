# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="AnHero, KDE-based crash handler for LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}
	>=kde-base/kdelibs-4.2.0"
RDEPEND="${DEPEND}"
