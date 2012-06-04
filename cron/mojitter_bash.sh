#!/bin/sh
BASEDIR=`dirname $0`
ruby ${BASEDIR}/../mojitter.rb -bash > ${BASEDIR}/out_tweet.txt
