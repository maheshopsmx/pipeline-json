# pipeline-json


## Architecture (Draft)

![Architecture](pics/Architecture.jpg)

## Steps to be followed 

1.  Clone the repo 

        git clone https://github.com/maheshopsmx/pipeline-json.git
    
        cd pipeline-json

2. Specify the stages in the stage-input.yml (for now it supports wait and manujudgement stages)

3. Run the script

        bash run.sh
        
4. Once it is ran in output it will prints the pipeline json and  save it to the spinnaker


5. It can also be saved in  pipeline-json/complete_pipeline.json
