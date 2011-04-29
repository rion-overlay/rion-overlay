# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Full-featured BitTorrent client plugin for LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}
		>=net-libs/rb_libtorrent-0.15.1"
RDEPEND="${DEPEND}
		virtual/leechcraft-task-show"
