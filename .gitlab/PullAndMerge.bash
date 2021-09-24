#!/bin/bash

WD=$(pwd)

echo ${WD}

set +e

bash << EOF
    echo "Cloning from ${MIRROR_SOURCE_REPO}"

    rm -rf git_source
    git init git_source

    pushd git_source
        git clone https://github.com/etpalmer63/amrex.git

        pushd amrex
            git checkout ${SOURCE_BRANCH}



           # #Remove GitHub CI 
           # git checkout ${SOURCE_BRANCH}
           # find . -regex ".*\.github.*\.yml" -print | xargs rm 
           # git rm .github/*yml
           # git commit -m "Remove GitHub Actions"

            #Merge SOURCE_BRANCH into main

            git checkout main
            git merge --no-ff ${SOURCE_BRANCH}
            git push origin main            

        popd
    popd

EOF
status=$(echo $?)


set -e

if [ ! ${status} == "0" ]; then
    exit ${status}
fi

