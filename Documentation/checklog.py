#!/usr/bin/env python

''' Mercurial hook ensuring ChangeLog QA

The hook intended to be used as a reminder for Gentoo overlay maintainers and
commiters. It checks going-to-be changeset for changes in *.ebuild files
and discards commit if no corresponding ChangeLog found.

Usage: add it to [hooks] section of your repo's `hgrc` file like this:
[hooks]
pretxncommit.chlog = `hg root`/Documentation/checklog.py
'''

import os
import subprocess
import sys

hg_process = subprocess.Popen(["hg", "tip", "--template", "{files}"],
                              stdout=subprocess.PIPE)

eb_dirs = []
chl_dirs = []

for ci_file in hg_process.stdout:
    #TODO: deal with Py3k bytetype returned from stdout (shlex.split)
    dir = os.path.dirname(ci_file)
    if ci_file.endswith('.ebuild') and dir not in eb_dirs:
        eb_dirs.append(dir)
    elif os.path.basename(ci_file) == "ChangeLog" and dir not in eb_dirs:
        chl_dirs.append(dir)

for path in eb_dirs:
    if path not in chl_dirs:
        eb_dirs.remove(path)

if eb_dirs:
    print("\n * Ebuilds in following directories were changed")
    print(" * but no changelogs commited")
    for i in eb_dirs:
        print(i)
    print('')
    sys.exit(1)

