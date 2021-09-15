#!/bin/bash -e
SYNC_INTERVAL="${SYNC_INTERVAL:=30}"
GIT_REPO_BRANCH="${GIT_REPO_BRANCH:=main}"

if [[ -z "${GIT_REPO}" ]]; then
    echo "Missing git repo URL"
    exit 1
fi

echo "GIT_REPO=$GIT_REPO"
echo "GIT_REPO_BRANCH=$GIT_REPO_BRANCH"
echo "SYNC_INTERVAL=$SYNC_INTERVAL"

while true; do
  if [ -d .git ]; then
    echo "Pulling..."
    git pull origin $GIT_REPO_BRANCH
    git submodule update --init --recursive --remote
  else
    echo "Cloning..."
    git clone --single-branch -b $GIT_REPO_BRANCH $GIT_REPO .
    git submodule update --init --recursive --remote
    if [ -d "/repo/.git-crypt" ]; then
      if [ ! -f "$GITCRYPT_SYMMETRIC_KEY" ]; then
        echo "[ERROR] Please verify your env variables (GITCRYPT_PRIVATE_KEY or GITCRYPT_SYMMETRIC_KEY)"
        exit 1
      else
        git-crypt unlock $GITCRYPT_SYMMETRIC_KEY
      fi
    fi
  fi
  echo "Done. Sleeping $SYNC_INTERVAL seconds..."
  sleep $SYNC_INTERVAL
done
