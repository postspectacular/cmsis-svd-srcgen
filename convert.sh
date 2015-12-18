#!/bin/bash
SAXON_PATH=~/dev/java/SaxonHE9-7-0-1J/

LANG=$1
SRC=$2
_PARAMS=($@)
PARAMS=${_PARAMS[@]:2:$#}

java -jar $SAXON_PATH/saxon9he.jar -xsl:lang-$LANG.xsl -s:$SRC $PARAMS
