#!/usr/bin/env bash
#
#  Nemo.podspec
#  Nemo
#
#  Created by Sinoru on 2015. 8. 11..
#  Copyright © 2015-2017 Sinoru. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#  http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

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
