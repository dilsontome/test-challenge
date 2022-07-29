#!/bin/bash

# A file named "file_diff.txt" contains the content of the command 'git diff --name-status' , in general the name of the files that have changed in a commit or pull request (add/modify/delete/rename).
# The content of the file file_diff.txt is as follows:
#     M     src/objects/Event.object
#     A     src/objects/Trading_Event__c.object
#     R     src/objects/ActiveScratchOrg.object
#     M     src/profiles/Admin.profile
#     D     src/reports/CACI_Imports/All_Closed.report
# The first column denotes the status of their respective files in second column.
# The files (e.g. Event.object) in column second literally exists in current directory path i.e. "src/objects" etc.
# Write a program or code snippet (any language you prefer) which should read the above "file_diff.txt" line by line and do following:
# - Capture the file name (e.g. Event.object) having status either modified or added (M/A) and write to a file added.txt.
# - Capture the file name (e.g. All_Closed.report) having status either rename or deleted (R/D) and write to a file removed.txt.
# - Please note the file names should not include paths.
# - Once file names are captured they should be copied/moved from existing paths to the path "deployPackage/added" or "deployPackage/removed" as per their respective status (deployPackage is the parent folder of removed and added folders)
# - For example: File names with status M/A and R/D should be copied/moved to "added" and "removed" folder respectively.

HowTo()
{
    # Display Help
    echo "This script get information from a file and split in two files"
    echo " added.txt and removed.txt separating for the first column."
    echo "After the files will be moved to other folders 'deployPackage/added' and 'deployPackage/removed'."
    echo "The content of this file is a result of command 'git diff --name-status'."
    echo "Below is the contents of file_diff.txt file:"
    echo "M       src/objects/Event.object"
    echo "A       src/objects/Trading_Event__c.object"
    echo "R       src/objects/ActiveScratchOrg.object"
    echo "M       src/profiles/Admin.profile"
    echo "D       src/reports/CACI_Imports/All_Closed.report"
    echo
    echo
    echo "Syntax: $(basename $0) [-f] FILENAME.txt [-s] GIT_STATUS [-o] OUTPUT_FILE.txt"
    echo "options:"
    echo "f     Set the file name to read"
    echo "s     Status to read from file"
    echo "        MA - For MODIFY and ADD"
    echo "        RD - For RENAME and DELETE"
    echo "o     File to output results"
    echo
}

main ()
{
    case $GIT_STATUS in
        MA) # MODIFY and ADD
            [ ! -d "deployPackage/added" ] && mkdir -p deployPackage/added
            awk -F / '$1 ~ /^A|^M/ {sub(/^[^:]+:/, "");  print $NF}' $FILE_NAME > ./added.txt
            awk '$1 ~ /^A|^M/ {sub(/^[^:]+:/, "");  print $NF}' $FILE_NAME | xargs mv -t deployPackage/added/
        ;;
        RD) # RENAME and DELETE
            [ ! -d "deployPackage/removed" ] && mkdir -p deployPackage/removed
            awk -F / '$1 ~ /^R|^D/ {sub(/^[^:]+:/, "");  print $NF}' $FILE_NAME > ./removed.txt
            awk '$1 ~ /^R|^D/ {sub(/^[^:]+:/, "");  print $NF}' $FILE_NAME | xargs mv -t deployPackage/removed
        ;;
        *)
            exit 1
        ;;
    esac
}

while getopts ":f:s:o:" option; do
    case $option in
        f) # Enter a name
            FILE_NAME=$OPTARG
        ;;
        s) # Enter a name
            GIT_STATUS=$OPTARG
        ;;
        *)
            HowTo
            exit 1
        ;;
    esac
done

if [[ -z $FILE_NAME ]]
then
    HowTo
elif [[ -z $GIT_STATUS ]]
then
    HowTo
else
    main
fi