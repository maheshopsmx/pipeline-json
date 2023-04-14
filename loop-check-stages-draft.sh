#! /bin/bash
git clone https://github.com/maheshopsmx/pipeline-json.git
cd pipeline-json
rm -rf /tmp/list
touch /tmp/list
stages=waitstage,manualjudgement
IFS=","
for liststages in $stages
do
  existone=waitstage,manualjudgement,deploymanifest
  IFS=","
  for checkstages in $existone
  do
    if [ "$liststages" = "$checkstages" ]
    then
       echo "Yes stage matches $liststages = $checkstages"
       ls | grep $checkstages >> /tmp/list
       cat /tmp/list
       exit 0
    else
       echo "Check Matching ...."
    fi
 done
done
