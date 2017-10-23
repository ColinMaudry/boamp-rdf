#!/bin/bash

    #curl -X POST http://localhost:5820/boamp/data -H "Content-type:application/rdf+xml" --data @"$file"
time ~/programs/stardog-5.0.4/bin/stardog data add -f RDF/XML boamp --remove-all $1 -v


