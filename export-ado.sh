#!/bin/sh

org=https://dev.azure.com/xxx
project=xxx
saName=xxx
saContainer=xxx

az extension add --name azure-devops --upgrade -y

az devops project list --org=$org -o table 

# az boards query --wiql "SELECT [System.Id], [System.Title], [System.AssignedTo], [System.State], [System.AreaPath], [System.IterationPath], [System.Tags], [System.CommentCount] FROM workitems WHERE [System.TeamProject] = '${project}' ORDER BY [System.IterationPath]" 

ids=$(az boards query --wiql "SELECT [System.Id] FROM workitems WHERE [System.TeamProject] = '${project}'  ORDER BY [System.IterationPath]" \
    --query '[].id' \
    --output tsv)

mkdir -p workitems

for id in $ids
do
    az boards work-item show --id $id -o json > workitems/$id.json
done

az storage blob upload-batch --account-name $saName -d $saContainer -s workitems/ --overwrite    