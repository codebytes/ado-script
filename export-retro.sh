#!/bin/sh

org=https://dev.azure.com/xxx
project=xxx
saName=xxx
saContainer=xxx
retro=xxx

# az extension add --name azure-devops --upgrade -y
# az devops project list --org=$org -o table 
# https://dev.azure.com/azurefasttrack/_apis/Contribution/HierarchyQuery/project/xxx
# https://azurefasttrack.extmgmt.visualstudio.com/_apis/ExtensionManagement/InstalledExtensions/ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/$retro/Documents
# https://azurefasttrack.visualstudio.com/_apis/Contribution/HierarchyQuery/project/xxx
# az devops invoke --area Contribution --resource HierarchyQuery --organization https://azurefasttrack.visualstudio.com --route-parameters scopeName="project" scopeValue="xxx" 

# https://azurefasttrack.extmgmt.visualstudio.com/_apis/ExtensionManagement/InstalledExtensions/ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/$retro/Documents
ids=$(az devops invoke --organization https://azurefasttrack.visualstudio.com --area ExtensionManagement --resource InstalledExtensions --api-version 7.1-preview --route-parameters extensionId="ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/$retro/Documents" --query "value[].id" -o tsv)

for id in $ids; do
    # https://azurefasttrack.extmgmt.visualstudio.com/_apis/ExtensionManagement/InstalledExtensions/ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/$retro/Documents/xxx
    board=$(az devops invoke --organization https://azurefasttrack.visualstudio.com --area ExtensionManagement --resource InstalledExtensions --api-version 7.1-preview --route-parameters extensionId="ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/$retro/Documents/$id")
    # echo $board
    data=$(az devops invoke --organization https://azurefasttrack.visualstudio.com --area ExtensionManagement --resource InstalledExtensions --api-version 7.1-preview --route-parameters extensionId="ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/$id/Documents")
    status=$?
    if [ $status -ne 0 ]; then
        echo "WARNING"
    else
        echo $data > $id.documents.json
    fi
done

# https://azurefasttrack.extmgmt.visualstudio.com/_apis/ExtensionManagement/InstalledExtensions/ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/xxx/Documents
# az devops invoke --organization https://azurefasttrack.visualstudio.com --area ExtensionManagement --resource InstalledExtensions --api-version 7.1-preview --route-parameters extensionId="ms-devlabs/team-retrospectives/Data/Scopes/Default/Current/Collections/xxx/Documents"