#!/bin/bash

die() {
  echo "${1}"
  exit 1
}

[ ! -d "net-im" ] && die "Please start this script in the overlay root"

list_plugins() {
  wget -O- https://github.com/psi-im/plugins/tree/master/$1 2>/dev/null | grep -oE '>\w+plugin<' | while read -r v; do echo ${v:1:-7}; done
}

PLUGINS_GENERIC=`list_plugins generic`
PLUGINS_UNIX=`list_plugins unix`
NEW_PLUGINS=""

for p in $PLUGINS_GENERIC $PLUGINS_UNIX; do
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
  echo "$(cat <<METACONTENT
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "http://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
	<herd>net-im</herd>
	<maintainer>
		<email>rion4ik@gmail.com</email>
		<name>rion</name>
	</maintainer>
	<longdescription lang="en">
	${longdesc}
	</longdescription>
</pkgmetadata>
METACONTENT
)" > "net-im/psi-${pn}/metadata.xml"

  arch=generic
  for pu in $PLUGINS_UNIX; do [ "$pu" = "${pn}plugin" ] && arch=unix; done
  dirvar=""
  [ "$arch" != "generic" ] && dirvar="PLUGIN_DIR=\"${arch}\""
  echo "$(cat <<EBUILDCONTENT
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# \$Header: \$

EAPI=6

${dirvar}
inherit psi-plugin

DESCRIPTION="${desc}"

KEYWORDS=""
IUSE=""
EBUILDCONTENT
)" >> "net-im/psi-${pn}/psi-${pn}-9999.ebuild"

  echo "# ChangeLog for net-im/psi-${pn}
# Copyright 1999-2017 Gentoo Foundation; Distributed under the GPL v2
# \$Header: \$

  `LANG=C date "+%d %b %Y"`; $USER <$USER@bots.ru> ChangeLog:
  generate ChangeLog" > "net-im/psi-${pn}/ChangeLog"

  ebuild "net-im/psi-${pn}/psi-${pn}-9999.ebuild" digest
  git add "net-im/psi-${pn}"

done

####### Add new ebuild to package.keywords and set #######
ALL_PLUGINS="$(grep psi-plugin -lr net-im/ --include '*ebuild' | cut -d '/' -f -2)"
(
  echo "net-im/psi::rion **"
  echo "net-im/psimedia::rion **"
  echo "net-im/qconf::rion **"
  echo "$ALL_PLUGINS" | awk '{print $1."::rion **"}'
) > Documentation/package.keywords/psi/psi.keywords
(
  echo "net-im/psi[plugins]"
  echo "net-im/psimedia[extras]"
  echo "$ALL_PLUGINS"
) > sets/psiplus
##########################################################

echo
echo "New ebuilds are ready for commit! :-)"
