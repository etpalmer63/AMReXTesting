#!/usr/bin/env bash


set -eu -o pipefail

sudo apt-get update 

sudo apt-get install -y --no-install-recommends\
  jq   \
  curl


# indetify the most recent comment associated with a PR 

curl   -H "Accept: application/vnd.github.v3+json"   https://api.github.com/repos/etpalmer63/AMReXTesting/issues/comments?direction=desc | jq .[0]


