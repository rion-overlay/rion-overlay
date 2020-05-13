# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Meta package for net-im/psi plugins"
HOMEPAGE="https://github.com/psi-im"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="attention autoreply birthdayreminder chess cleaner clientswitcher conferencelogger contentdownloader enummessages extendedmenu extendedoptions gnupg gomokugame historykeeper icqdie image imagepreview jabberdisk juick messagefilter omemo openpgp otr pepchangenotify qipxstatuses screenshot skins stopspam storagenotes translate videostatus watcher"

RDEPEND=""

for plugin in ${IUSE}; do
 RDEPEND+=" ${plugin}? ( >=net-im/psi-${plugin}-${PV} )"
done
