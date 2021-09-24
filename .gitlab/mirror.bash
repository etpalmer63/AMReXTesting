#!/bin/bash

WD=$(pwd)

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
        #git remote add origin ${MIRROR_SOURCE_REPO}
        #git config remote.origin.mirror true

        #git fetch origin --prune

        pushd amrex
            git checkout ${SOURCE_BRANCH}
        #popd

        builtin echo -e "#!/usr/bin/env bash
builtin echo ${TARGET_REPO_PAT}" > ${WD}/askpass

        #pushd amrex
        #echo "Adding Remote Taget ${MIRROR_TARGET_REPO}"
            git remote add target ${MIRROR_TARGET_REPO}

        #Make sure to carefully choose what branches to push. Branches may trigger jobs in the target repo. 
        #Protected branches do not translate across gitlab, github, bitbucket etc.
        #git push target --prune +refs/remotes/origin/main:refs/heads/main +refs/tags/*:refs/tags/*
        #echo "git push target ${SOURCE_BRANCH}:main"
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

rm -rf ${wd}/askpass

set -e

if [ ! ${status} == "0" ]; then
    exit ${status}
fi

