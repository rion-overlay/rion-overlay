# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Meta package for net-im/psi plugins"
HOMEPAGE="http://psi-dev.googlecode.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
# echo $(eix --only-names net-im/psi- | cut -d '-' -f 3) | fold -w 80 -s
IUSE="attention autoreply birthdayreminder captchaforms chess cleaner clientswitcher conferencelogger contentdownloader extendedmenu extendedoptions gmailservice gnome3support gnupg gomokugame historykeeper icqdie image jabberdisk juick otr pepchangenotify plugins psto qipxstatuses screenshot skins stopspam storagenotes translate videostatus watcher yandexnarod"

RDEPEND=""

for plugin in ${IUSE/otr}; do
	RDEPEND+=" ${plugin}? ( >=net-im/psi-${plugin}-${PV} )"
done

RDEPEND+=" otr? ( net-im/psi-otr )"
