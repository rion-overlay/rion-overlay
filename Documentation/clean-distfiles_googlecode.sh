#!/bin/sh
# clean-distfiles_googlecode.sh

googleproject="rion-overlay"

# list of distfiles
grep -e DIST \
	$(find -type f -name Manifest) |\
	awk '{print $2}'|\
	sort -u > /tmp/distfiles_overlay

# list of downloads
wget -O- \
	"http://code.google.com/p/${googleproject}/downloads/list?can=1&q=&colspec=Filename" |\
	grep \
		-e "http://${googleproject}.googlecode.com/files/" |\
	sed \
		-e "s#^ <a href=\"http://${googleproject}.googlecode.com/files/##" \
		-e 's/".*//' |\
	sort > /tmp/distfiles_googlecode

# removed from overlay
diff --unchanged-line-format='' --old-line-format='' --new-line-format='%L' \
	/tmp/distfiles_overlay \
	/tmp/distfiles_googlecode \
	|sort > /tmp/distfiles_remove

#cat /tmp/distfiles_remove

while read f
do
	echo xdg-open "http://code.google.com/p/${googleproject}/downloads/delete?name=${f}"
done < /tmp/distfiles_remove
