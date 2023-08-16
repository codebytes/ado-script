#!/bin/sh

org=https://dev.azure.com/xxx
project=xxx
saName=xxx
saContainer=xxx


# FIRST, Make sure you have the devops cli extension installed.
# az extension add --name azure-devops --upgrade -y

# NEXT, login into Azure Devops and create a pat
# PAT must have work-items READ, extensions data READ, and extensions READ
# az devops login --org $org

# az devops project list --org=$org -o table 
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