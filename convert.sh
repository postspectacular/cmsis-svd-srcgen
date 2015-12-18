#!/bin/sh
SAXON_PATH=~/dev/java/SaxonHE9-7-0-1J/

java -jar $SAXON_PATH/saxon9he.jar -xsl:lang-$1.xsl -s:$2
