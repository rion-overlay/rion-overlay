#!/bin/sh
# clean-distfiles_googlecode.sh

googleproject="rion-overlay"

manifests="$(find -type f -name Manifest)"
if [ "x$manifests" = "x" ];
then
	echo "No Manifests in current directory"
	exit 1
fi

# list of distfiles
grep -e DIST \
	$manifests |\
	awk '{print $2}'|\
	sort -u > /tmp/distfiles_overlay

# list of downloads
wget -O- \
	"http://code.google.com/p/${googleproject}/downloads/list?can=1&q=&colspec=Filename" |\
	grep \
		-e "http://${googleproject}.googlecode.com/files/" |\
	sed \
		-e "s#^ <a href=\"http://${googleproject}.googlecode.com/files/\([^\"]*\)\".*#\1#" |\
	sort > /tmp/distfiles_googlecode

# removed from overlay
diff --unchanged-line-format='' --old-line-format='' --new-line-format='%L' \
	/tmp/distfiles_overlay \
	/tmp/distfiles_googlecode \
	|sort > /tmp/distfiles_remove

#cat /tmp/distfiles_remove

while read f
do
	xdg-open "http://code.google.com/p/${googleproject}/downloads/delete?name=${f}" &
done < /tmp/distfiles_remove
