#!/usr/bin/env bash

REGISTRY=${1:-}
TOKEN=${2:-}

npm config set registry=$REGISTRY

if [[ "$TOKEN" != "" ]]; then
    npm config set $TOKEN
fi

npm install -g $@

npm config set registry=https://registry.npmjs.org/
npm config set //registry.npmjs.org/:_authToken=""