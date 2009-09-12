#!/bin/sh

find . -iname '*.ebuild' | \
while read f; do
	[[ $@ ]] && echo $f | egrep -v $@ || echo $f
done | \
xargs -I{} ebuild {} digest
