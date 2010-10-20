# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Meta package for net-im/psi plugins"
HOMEPAGE="http://code.google.com/p/psi-dev"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="attention autoreply birthdayreminder captchaforms chess cleaner conferencelogger contentdownloader extendedoptions gmailnotify
historykeeper icqdie image juick qipxstatuses screenshot skins stopspam storagenotes translate videostatus watcher"

RDEPEND=""

for plugin in $IUSE; do
	RDEPEND+=" ${plugin}? ( >=net-im/psi-${plugin}-${PV} )"
done
