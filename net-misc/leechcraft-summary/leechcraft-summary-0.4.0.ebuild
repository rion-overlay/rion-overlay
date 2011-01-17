# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Summary which shows all the downloads, events and statuses in LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}"
