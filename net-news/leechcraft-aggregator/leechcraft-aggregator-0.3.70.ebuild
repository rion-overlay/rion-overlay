# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit confutils leechcraft

DESCRIPTION="Aggregator, the full-featured RSS/Atom feed reader for LeechCraft."

IUSE="debug sqlite postgres"
DEPEND="=net-misc/leechcraft-core-${PV}[postgres?,sqlite?]"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_setup() {
	confutils_require_any postgres sqlite
}
KEYWORDS="~amd64"
