#!/bin/bash


for file in `ls $1/APPEL_OFFRE/*.jsonld | xargs`
do
    echo "$file..."
    curl -X POST http://localhost:3030/boamp/data -H "Content-type:application/ld+json" --data @"$file"
done
