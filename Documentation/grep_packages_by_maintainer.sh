#!/bin/sh

if [ -z "$1" ]; then
  echo "Usage: $0 emailof@maintainer"
  exit 1;
fi

find ./ -name metadata.xml -exec grep "<email>$1</email>" -H '{}' \; | sed 's:./\(.*\)/metadata.xml.*:\1:' | sort -u
