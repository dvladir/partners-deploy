#!/bin/bash
ARC=$1
IMG=$2
SRV=$3
echo "RECREATE $ARC $IMG $SRV"
docker import $ARC $IMG
docker image prune -f
docker-compose up --force-recreate --no-deps -d $SRV