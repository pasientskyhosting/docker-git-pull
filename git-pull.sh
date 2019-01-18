#!/bin/bash

echo "BRANCH=$BRANCH"
echo "URL=$URL"

DELAY="${SLEEP:=30}"
echo "SLEEP=$DELAY"

while true; do
  if [ -d .git ]; then
    echo "Pulling..."
    git pull origin $BRANCH
    git submodule update --init --recursive --remote
  else
    echo "Cloning..."
    git clone --single-branch -b $BRANCH $URL .
    git submodule update --init --recursive --remote
  fi
  echo "Done. Sleeping $DELAY seconds..."
  sleep $DELAY
done