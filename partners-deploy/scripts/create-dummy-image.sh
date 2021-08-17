#!/bin/bash
readonly TRUE=1
readonly FALSE=0

isImageExists(){
  imageName=$1
  isExists=$(docker images --format "{{.Repository}}:{{.Tag}}" "$imageName")
  if [ -z "$isExists" ]
  then
    echo $FALSE
  else
    echo $TRUE
  fi
}

createDummyImage(){
  imageName=$1
  isExists=$(isImageExists "$imageName")
  if [ "$isExists" -eq $FALSE ]
  then
    docker build -t "$imageName" ./empty
    echo "Dummy image $imageName created"
  else
    echo "Image $imageName already exists"
  fi
}

createDummyImage $1
