#!/usr/bin/env bash

set -eu -o pipefail

sudo apt-get update 

sudo apt-get install -y --no-install-recommends\
  jq   \
  curl


# indetify the PR associated with second most recent comment 

PR_ID=$(curl -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/etpalmer63/AMReXTesting/events | jq .[1].payload.issue.number)


# identify forked branch from which the 2nd most recent comment came 

CONTENT=$(curl -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/etpalmer63/AMReXTesting/pulls/$PR_ID) 


REPO_URL=$(jq -r '.head.repo.html_url' <<< "${CONTENT}")

SHA=$(jq -r '.head.sha' <<< "${CONTENT}")

PR_BRANCH=$(jq -r '.head.ref' <<< "${CONTENT}")

echo PR ID Number: $PR_ID
echo PR Branchname: $PR_BRANCH
echo Repo: $REPO_URL
echo sha: $SHA

#Trigger GitLab CI, pass variables
# succeeds at command line

curl -X POST\
     -F "token=$1" \
     -F "ref=main" \
     -F "variables[PR_ID]=${PR_ID}" \
     -F "variables[PR_BRANCH]=${PR_BRANCH}" \
     https://software.nersc.gov/api/v4/projects/307/trigger/pipeline






