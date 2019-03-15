#!/usr/bin/env bash

set -e

for package in `ls -d app_microservices/* core_microservices/* core core/gif-contracts shared/* cli`
do
  echo "Install dependencies for $package"
  (
    [ $CI ] && cp .npmrc_config $package/.npmrc

    cd $package
    npm ci
  )
done
