# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Flexible and customizable notifications framework for LeechCraft."

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="=net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}"

pkg_postinst() {
	einfo " + Advanced Notifications supports playing sounds on various"
	einfo "   events. Install some media playback plugin to enjoy this"
	einfo "   feature (media-video/leechcraft-lmp will do, for example)."
}
