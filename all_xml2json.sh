#!/bin/bash

current_dir=`pwd`
count=`ls data2017/*.xml | wc -l`
i=0

echo "[" > ./big.json

for file in `ls data2017/*.xml | xargs`
do
	./xml2json $file >> ./big.json
done

echo "]" >> ./big.json




