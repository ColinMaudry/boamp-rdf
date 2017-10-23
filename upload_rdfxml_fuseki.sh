#!/bin/bash

    #curl -X POST http://localhost:5820/boamp/data -H "Content-type:application/rdf+xml" --data @"$file"
#time ~/programs/stardog-5.0.4/bin/stardog data add -f RDF/XML -g urn:$2 boamp --remove-all $1 -v
for file in `find $1 -name '*.xml'`
do
curl -X POST -H "Content-type: application/xml+rdf" https://colin:$2@triplestore@maudry.com/boamp/data?graph=urn%3Agraph%3Aboamp2016 --data-binary @"$file"
done
