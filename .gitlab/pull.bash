#!/bin/bash

WD=$(pwd)

echo ${WD}


builtin echo -e "#!/usr/bin/env bash
builtin echo ${MIRROR_REPO_PAT}" > ${WD}/askpass
chmod +x ${WD}/askpass
export GIT_ASKPASS=${WD}/askpass

set +e

bash << EOF
    echo "Cloning from ${MIRROR_SOURCE_REPO}"

    rm -rf source
    #git init --bare source
    git init source

    pushd source
        git clone https://github.com/etpalmer63/amrex.git

        pushd amrex
            git checkout ${SOURCE_BRANCH}

            builtin echo -e "#!/usr/bin/env bash
builtin echo ${TARGET_REPO_PAT}" > ${WD}/askpass


            #Remove GitHub CI 
            git checkout ${SOURCE_BRANCH}
            find . -regex ".*\.github.*\.yml" -print | xargs rm 
            git rm .github/*yml
            git commit -m "Remove GitHub Actions"

                        

            git push target ${SOURCE_BRANCH}:main --force
        popd
    popd

EOF
status=$(echo $?)

rm -rf ${WD}/askpass

set -e

if [ ! ${status} == "0" ]; then
    exit ${status}
fi

