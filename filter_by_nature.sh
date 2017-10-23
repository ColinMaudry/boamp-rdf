#!/bin/bash

# xml2json = https://github.com/Cheedoong/xml2json


xml_dir=$1/xml
json_dir=$1/json
jsonld_dir=$1/jsonld

mkdir $json_dir
mkdir $jsonld_dir


count=`find $xml_dir -name '*.xml' | wc -l`
i=0

echo "$count XML files to process."
echo ""


echo "Converting XML files to JSON..."

for file in `find $xml_dir -name '*.xml'`
do
	./xml2json $file > $file.json
    mv $file.json $json_dir
done

echo "Categorizing files by nature..."

mkdir $json_dir/ATTRIBUTION
mkdir $json_dir/APPEL_OFFRE
mkdir $json_dir/INTENTION_CONCLURE
mkdir $json_dir/RECTIFICATIF
mkdir $json_dir/PERIODIQUE
mkdir $json_dir/MODIFICATION
mkdir $json_dir/PRE-INFORMATION

mkdir $jsonld_dir/ATTRIBUTION
mkdir $jsonld_dir/APPEL_OFFRE
mkdir $jsonld_dir/INTENTION_CONCLURE
mkdir $jsonld_dir/RECTIFICATIF
mkdir $jsonld_dir/PERIODIQUE
mkdir $jsonld_dir/MODIFICATION
mkdir $jsonld_dir/PRE-INFORMATION



for file in `find $json_dir -name '*.json'`
do
    nature=`cat $file | grep -oP '(?<="NATURE":{")[A-Z_-]*(?=")' |  head -n 1`
    mv -v $file $json_dir/$nature/ | grep "failed"
done

countAttri=`find $json_dir/ATTRIBUTION -name '*.json' | wc -l`
countAppel=`find $json_dir/APPEL_OFFRE -name '*.json'  | wc -l`
countIntention=`find $json_dir/INTENTION_CONCLURE -name '*.json' | wc -l`
countRecti=`find $json_dir/RECTIFICATIF -name '*.json' | wc -l`
success=$(( countAttri + countAppel + countIntention + countRecti))
failed=$(( count - success ))

echo ""
echo "Attributions: $countAttri"
echo "Appels d'offres: $countAppel"
echo "Intentions de conclure: $countIntention"
echo "Rectificatifs: $countRecti"
echo ""
echo "Success: $success"
echo "Failed: $failed"

echo ""
echo "Converting appel d'offres to JSON-LD..."
for file in `find $json_dir/APPEL_OFFRE -name '*.json'`
do
    jq -f filtre-appel-offres.jq $file > $file.jsonld
    mv $file.jsonld $jsonld_dir/APPEL_OFFRE/
done

countAppelLd=`find $jsonld_dir/APPEL_OFFRE -name '*.jsonld' | wc -l`
echo "Success: $countAppelLd"
echo "Failed: $(($countAppel - $countAppelLd))"

echo ""
echo "Converting attributions to JSON-LD..."
for file in `find $json_dir/ATTRIBUTION -name '*.json'`
do
    jq -f filtre-attribution.jq $file > $file.jsonld
    mv $file.jsonld $jsonld_dir/ATTRIBUTION/
done

countAttriLd=`find $jsonld_dir/ATTRIBUTION -name '*.jsonld' | wc -l`
echo "Success: $countAttriLd"
echo "Failed: $(($countAttri - $countAttriLd))"
