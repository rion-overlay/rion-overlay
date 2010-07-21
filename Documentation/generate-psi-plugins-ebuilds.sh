#!/bin/bash

die() {
  echo "${1}"
  exit 1
}

[ ! -d "net-im" ] && die "Please start this script in the overlay root"

PLUGINS=`svn ls http://psi-dev.googlecode.com/svn/trunk/plugins/generic`
NEW_PLUGINS=""

for p in $PLUGINS; do
  pn=${p/plugin\//}
  [ ! -d "net-im/psi-${pn}" ] && NEW_PLUGINS="${NEW_PLUGINS} ${pn}"
done

[ "${NEW_PLUGINS}" == "" ] && {
  echo "no new plugins found."
  exit 0
}

echo "Found next new plugins:${NEW_PLUGINS}"
echo -ne "Do you want to generate ebuilds for them? [\033[4mY\033[0m/n]"

read -n 1 act
echo
case $act in
  n|N) echo "ok. nothing is left to do"; exit 0 ;;
  *) echo "Generating ebuilds.." ;;
esac

for pn in $NEW_PLUGINS; do
  echo "Creating ebuild for ${pn} plugin."
  echo -n "Enter DESCRIPTION ebuild's field: "
  read desc
  [ "${desc}" == "" ] && {
    echo "You must enter at least 1 symbol. skipping plugin"
    continue
  }
  echo -n "Enter long desciption for metadata: "
  read longdesc
  mkdir "net-im/psi-${pn}" || die "failed to create plugin's dir"
  echo "$(cat <<'METACONTENT'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
	<herd>net-im</herd>
	<maintainer>
		<email>rion4ik@gmail.com</email>
		<name>Il'nykh Sergey</name>
	</maintainer>
	<longdescription lang="en">
METACONTENT
)" > "net-im/psi-${pn}/metadata.xml"
  echo "${longdesc}" >> "net-im/psi-${pn}/metadata.xml"
  echo -e "</longdescription>\n</pkgmetadata>" >> "net-im/psi-${pn}/metadata.xml"

  echo "$(cat <<'EBUILDCONTENT'
# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit psiplus-plugin


EBUILDCONTENT
)" > "net-im/psi-${pn}/psi-${pn}-9999.ebuild"

  echo "DESCRIPTION=\"${desc}\"" >> "net-im/psi-${pn}/psi-${pn}-9999.ebuild"
  echo "$(cat <<'EBUILDCONTENT'
HOMEPAGE="http://psi-dev.googlecode.com"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
EBUILDCONTENT
)" >> "net-im/psi-${pn}/psi-${pn}-9999.ebuild"

  echo "# ChangeLog for net-im/psi-${pn}
# Copyright 1999-2010 Gentoo Foundation; Distributed under the GPL v2
# \$Header: \$

  `LANG=C date "+%d %b %Y"`; $USER <$USER@bots.ru> ChangeLog:
  generate ChangeLog" > "net-im/psi-${pn}/Changelog"

  ebuild "net-im/psi-${pn}/psi-${pn}-9999.ebuild" digest
  hg add "net-im/psi-${pn}"

done

####### Add new ebuild to package.keywords and set #######
echo "net-im/psi-${pn} **" >> Documentation/package.keywords/psi/psi.keywords
echo "net-im/psi-${pn}" >> sets/psiplus 
##########################################################

echo
echo "New ebuilds are ready for commit! :-)"
