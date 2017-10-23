#!/bin/bash

main_dir=$1
if [ -n $main_dir ]; then

cd $main_dir
mkdir zips
ls *.taz | xargs -i tar -xf {}
mv *.taz zips
mkdir xml
mkdir html

find . -name '*.xml' -type f  -exec mv -t xml {} +
find . -name '*.html' -type f  -exec mv -t html {} +

rmdir *

#rm -rf ./*/

fi
