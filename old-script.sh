#! /bin/bash

echo "Fetch the stages from input file ..."

stages=$(yq -r .stages stage-input.yml)

if [[ -z "$stages" ]]; then
  echo "ERROR: Please specify the stages in the input file....."
  exit 1
else 
  echo "stages are : $stages"
  stageid=
  refid=1
  filestg=wait_stage.json
  IFS=","
  for pipestage in $stages
  do
    echo value is $pipestage
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
  done
  cp plain_pipeline_template.json final_pipeline.json
  cat final_pipeline.json
fi

