# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="LCFTP, FTP client for LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}
		>=net-misc/curl-7.19.4"
RDEPEND="${DEPEND}
		virtual/leechcraft-task-show"
KEYWORDS="~amd64 ~x86"
