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

PR_BRANCHNAME=$(jq -r '.head.ref' <<< "${CONTENT}")

echo PR Number: $PR_NUMBER
echo PR Branchname: $PR_BRANCHNAME
echo Repo: $REPO_URL
echo sha: $SHA

#Trigger GitLab CI, pass variables

curl -X POST\
     -F token=${{secrets.GITLAB_TRIGGER_TOKEN}} \
     -F "ref=main" \
     -F "variables[PR_NUMBER]=$PR_NUMBER" \
     -F "variables[PR_BRANCHNAME]=$PR_BRANCHNAME" \
     https://software.nersc.gov/api/v4/projects/307/trigger/pipeline






