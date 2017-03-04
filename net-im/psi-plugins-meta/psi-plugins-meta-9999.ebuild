# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package for net-im/psi plugins"
HOMEPAGE="https://github.com/psi-im"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="attention autoreply birthdayreminder captchaforms chess cleaner clientswitcher conferencelogger contentdownloader enummessages extendedmenu extendedoptions gmailservice gnome3support gnupg gomokugame historykeeper httpupload icqdie image imagepreview jabberdisk juick messagefilter otr pepchangenotify psto qipxstatuses screenshot skins stopspam storagenotes translate videostatus watcher"

RDEPEND=""

for plugin in ${IUSE}; do
	RDEPEND+=" ${plugin}? ( >=net-im/psi-${plugin}-${PV} )"
done
