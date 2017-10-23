#!/bin/bash

rm -r $2
mkdir -p $2

time java -jar saxon9he.jar -s:$1 -xsl:xslt/boamp.xsl -o:$2
