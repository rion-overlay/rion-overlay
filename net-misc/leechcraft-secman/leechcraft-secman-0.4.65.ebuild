# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="SecMan is a security and personal data manager for LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}"
