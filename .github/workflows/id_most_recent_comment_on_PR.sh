set -eu -o pipefail

sudo apt-get update 

sudo apt-get install -y --no-install-recommends\
  jq   \
  curl


# indetify the most recent comment associated with a PR 

curl  https://api.github.com/repos/etpalmer63/AMReXTesting/issues/comments | jq

