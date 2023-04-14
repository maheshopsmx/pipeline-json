#! /bin/bash
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
       echo "Yes stage matches $stages = $checkstages"
       break
    else
       echo "Check Matching ...."
    fi
 done
done
