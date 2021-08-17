#!/bin/bash
my_dir="$(dirname "$0")"

$my_dir/create-dummy-image.sh dvladir:partners-api

docker-compose up -d