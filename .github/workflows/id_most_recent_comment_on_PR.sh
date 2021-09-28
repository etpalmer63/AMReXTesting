#!/usr/bin/env bash


set -eu -o pipefail

sudo apt-get update 

sudo apt-get install -y --no-install-recommends\
  jq   \
  curl


# indetify the PR associated with second most recent comment 

PR_NUMBER=$(curl -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/etpalmer63/AMReXTesting/events | jq .[1].payload.issue.number)


# identify forked branch from which the 2nd most recent comment came 

CONTENT=$(curl -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/etpalmer63/AMReXTesting/pulls/$PR_NUMBER) 


REPO_URL=$(jq -r '.head.repo.html_url' <<< "${CONTENT}")

SHA=$(jq -r '.head.sha' <<< "${CONTENT}")




echo PR Number: $PR_NUMBER
echo Repo: $REPO_URL
echo sha: $SHA



