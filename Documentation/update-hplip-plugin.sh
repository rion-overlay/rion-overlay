#!/bin/bash

docdir=`dirname "$0"`

last=`wget -qO- http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/ | grep -oP 'hplip[^"]*run' | tail -n1`

version=`echo $last | grep -oP '\d+(\.\d+)*'`

last_ebuild_version=`find "$docdir/../net-print/hplip-plugin" -name '*.ebuild' | grep -oP '\d+(\.\d+)*' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | tail -n1`

# TODO handle revisions
if [ "$version" = "$last_ebuild_version" ]; then
  echo "Version is unchanged"
  exit 0;
fi

cp "$docdir/../net-print/hplip-plugin/hplip-plugin-${last_ebuild_version}.ebuild" "$docdir/../net-print/hplip-plugin/hplip-plugin-${version}.ebuild"

cd "$docdir/../net-print/hplip-plugin"

ebuild "hplip-plugin-${version}.ebuild" digest
hg add "hplip-plugin-${version}.ebuild"
echangelog "version bump"
