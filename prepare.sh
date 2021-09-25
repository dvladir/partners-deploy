#!/bin/bash

DIR="./partners-deploy"
ARC="./partners-deploy.tar.gz"

echo "CHECK ARCHIVE"
if ! [ -f "$ARC" ]; then
  echo "$ARC not exists"
  exit 1
fi

if [ -d "$DIR" ]; then
  echo "REMOVE PREVIOUS"
  cd $DIR
  docker-compose down
  cd ./..
  rm -rf $DIR
fi

echo "UNPACK NEW"
tar -xf $ARC
chown -R $USER $DIR
chmod -R 755 $DIR

cd $DIR
#./scripts/run.sh
cd ./..