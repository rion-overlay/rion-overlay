#!/bin/sh

find ${1} -iname '*.ebuild' | xargs -I{} ebuild {} digest
