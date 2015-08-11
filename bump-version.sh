#!/bin/bash

CURRENT_VERSION=$(agvtool vers -terse)
CURRENT_MARKETING_VERSION=$(agvtool mvers -terse1)
NEW_VERSION=$(git rev-list HEAD --count)
NEW_MARKETING_VERSION=$1

if [ -z "$1" ]; then
   NEW_MARKETING_VERSION=$CURRENT_MARKETING_VERSION
fi

if [ ${NEW_VERSION} != ${CURRENT_VERSION} ]; then
    agvtool new-version ${NEW_VERSION}
fi

if [ ${NEW_MARKETING_VERSION} != ${CURRENT_MARKETING_VERSION} ]; then
    agvtool new-marketing-version "${NEW_MARKETING_VERSION}"
fi
