#!/bin/sh

find . -iname '*.ebuild' | \
while read f; do
	if [[ $@ ]]; then
		echo $f | egrep -v $@
	else
		echo $f
	fi
done | \
xargs -I{} ebuild {} digest
