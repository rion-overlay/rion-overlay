# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="vGrabber allows to find, stream and save audio and video from VKontakte in LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}
		virtual/leechcraft-downloader-http"
KEYWORDS="~amd64 ~x86"
