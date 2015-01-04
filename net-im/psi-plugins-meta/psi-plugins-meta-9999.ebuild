# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Meta package for net-im/psi plugins"
HOMEPAGE="http://psi-dev.googlecode.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="attention autoreply birthdayreminder captchaforms chess cleaner clientswitcher conferencelogger contentdownloader extendedoptions gmailservice
historykeeper icqdie image juick otr pepchangenotify extendedmenu psto qipxstatuses screenshot skins stopspam storagenotes translate videostatus watcher"

RDEPEND=""

for plugin in ${IUSE/otr}; do
	RDEPEND+=" ${plugin}? ( >=net-im/psi-${plugin}-${PV} )"
done

RDEPEND+=" otr? ( net-im/psi-otr )"
