# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EAPI="2"

DESCRIPTION="Meta package for net-im/psi plugins"
HOMEPAGE="http://code.google.com/p/psi-dev"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 ~sparc x86 ~x86-fbsd"

PSIPLUS_PLUGINS="attention autoreply birthdayreminder cleaner conferencelogger extendedoptions gmailnotify
image icqdie juick screenshot stopspam storagenotes translate watcher"
IUSE="${PSIPLUS_PLUGINS}"

DEPEND=""
RDEPEND="${DEPEND}"

for plugin in $PSIPLUS_PLUGINS; do
	RDEPEND="${RDEPEND} ${plugin}? ( net-im/psi-${plugin} )"
done



