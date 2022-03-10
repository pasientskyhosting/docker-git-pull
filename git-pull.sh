#!/bin/bash -e
SYNC_INTERVAL="${SYNC_INTERVAL:=30}"
GIT_REPO_BRANCH="${GIT_REPO_BRANCH:=main}"
PARSERS_DIR="${PARSERS_DIR:=/etc/crowdsec/parsers/}"
COLLECTIONS_DIR="${COLLECTIONS_DIR:=/etc/crowdsec/collections/}"
POSTOVERFLOWS_DIR="${POSTOVERFLOWS_DIR:=/etc/crowdsec/postoverflows/}"
SCENARIOS_DIR="${SCENARIOS_DIR:=/etc/crowdsec/scenarios/}"

if [[ -z "${GIT_REPO}" ]]; then
    echo "Missing git repo URL"
    exit 1
fi

if [ ! -d "${PARSERS_DIR}" ]; then
  echo "Parsers directory directory does not exist"
  exit 1
fi

if [ ! -d "${COLLECTIONS_DIR}" ]; then
  echo "Collections directory directory does not exist"
  exit 1
fi

if [ ! -d "${POSTOVERFLOWS_DIR}" ]; then
  echo "Postoverflows directory directory does not exist"
  exit 1
fi

if [ ! -d "${SCENARIOS_DIR}" ]; then
  echo "Scenarios directory directory does not exist"
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
  # update the collections if diff found
  if [[ $(diff <(find /repo/collections -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ") <(find ${COLLECTIONS_DIR} -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ")) != "" ]]; then 
    find ${COLLECTIONS_DIR} -type f -delete
    cp -u -r /repo/collections/. ${COLLECTIONS_DIR}
  fi
  # update the postoverflows if diff found
  if [[ $(diff <(find /repo/postoverflows -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ") <(find ${POSTOVERFLOWS_DIR} -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ")) != "" ]]; then 
    find ${POSTOVERFLOWS_DIR} -type f -delete
    cp -u -r /repo/postoverflows/. ${POSTOVERFLOWS_DIR}
  fi
  # update the parsers if diff found
  if [[ $(diff <(find /repo/parsers -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ") <(find ${PARSERS_DIR} -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ")) != "" ]]; then 
    find ${PARSERS_DIR} -type f -delete
    cp -u -r /repo/parsers/. ${PARSERS_DIR}
  fi
  # update the scenarios if diff found
  if [[ $(diff <(find /repo/scenarios -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ") <(find ${SCENARIOS_DIR} -type f -exec md5sum {} + | sort -k 2 | cut -f1 -d" ")) != "" ]]; then 
    find ${SCENARIOS_DIR} -type f -delete
    cp -u -r /repo/scenarios/. ${SCENARIOS_DIR}
  fi
  
  echo "Done. Sleeping $SYNC_INTERVAL seconds..."
  sleep $SYNC_INTERVAL
done
