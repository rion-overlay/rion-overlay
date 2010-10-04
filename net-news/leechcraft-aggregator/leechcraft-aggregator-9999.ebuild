# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit confutils leechcraft

DESCRIPTION="Aggregator, the full-featured RSS/Atom feed reader for LeechCraft."

IUSE="debug mysql sqlite postgres"
DEPEND="=net-misc/leechcraft-core-${PV}[mysql?,postgres?,sqlite?]"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"

pkg_setup() {
	confutils_require_any mysql postgres sqlite
}
