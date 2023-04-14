#! /bin/bash
git clone https://github.com/maheshopsmx/pipeline-json.git > /dev/null
cd pipeline-json
rm -rf ../list
touch ../list
stages=aws,waitstage,manualjudgement
IFS=","
for liststages in $stages
do
  existone=waitstage,manualjudgement,deploymanifest
  IFS=","
  for checkstages in $existone
  do
    if [ "$liststages" == "$checkstages" ]
    then
       echo "Yes stage matches $liststages = $checkstages"
       ls | grep $checkstages >> ../list
       if [ "$?" != "0" ]
       then
          echo "The stage name:--> $liststages not found .." 
       fi
    #else
    #   echo "Check Matching ...."
    fi
 done
done
stageid=
refid=1
IFS=","
while read -r filestg; do
    echo value is $filestg
    jq  --argjson stage "$(<$filestg)" '.stages += [$stage]' plain_pipeline_template.json > formulate.json
    if [[ -z "$stageid" ]]; then
    jq --argjson refstage '{"refId":"'$refid'","requisiteStageRefIds":['"$stageid"']}' '.stages['"$stageid"'] += $refstage' formulate.json > inter.json
    else
    jq --argjson refstage '{"refId":"'$refid'","requisiteStageRefIds":["'"$stageid"'"]}' '.stages['"$stageid"'] += $refstage' formulate.json > inter.json
    fi
    if [ $? != 0 ]; then
      echo "Error occured in YAML processing, please check the logs"
      exit 1
    fi
    rm -rf plain_pipeline_template.json formulate.json final_pipeline.json
    mv inter.json plain_pipeline_template.json
    rm -rf inter.json
    filestg=manualjudgement_stage.json
    refid=$((refid+1))
    stageid=$((stageid+1))
done < ../list
rm -rf ../list
mkdir final-pipeline
cp plain_pipeline_template.json final-pipeline/final_pipeline.json
cat final-pipeline/final_pipeline.json
