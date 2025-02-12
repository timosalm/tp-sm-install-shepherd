#!/bin/bash

set -x
set -eo pipefail

artifactory_token=$(echo $SUPPORT_PORTAL_TOKEN | jq -r .access_token)
sshpass -p $jumpbox_password ssh kubo@$jumpbox_ip 'ARTIFACTORY_TOKEN="$artifactory_token" ARTIFACTORY_USER="$ARTIFACTORY_USER" TANZU_SM_VERSION="$TANZU_SM_VERSION" bash -s' < tp-install-jumpbox.sh