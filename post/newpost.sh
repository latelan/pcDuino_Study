#! /bin/sh
#
# make new post file.
# Usage: ./newpost.sh "this is a new post"
#

date=`date +%Y-%m-%d`
title=`echo $1 | sed 's/\s\+/ /g' | sed 's/ /-/g' | sed 's/-$//g'`
file=${date}-${title}.md

echo $file && touch $file
