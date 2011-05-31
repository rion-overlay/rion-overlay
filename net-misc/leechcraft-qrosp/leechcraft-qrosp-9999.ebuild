# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Qrosp, scrpting support for LeechCraft via Qross."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}
	dev-libs/qrosscore"
RDEPEND="${DEPEND}"
