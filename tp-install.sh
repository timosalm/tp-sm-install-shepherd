#!/bin/bash

set -x
set -eo pipefail

sshpass -p $jumpbox_password ssh kubo@$jumpbox_ip 'ARTIFACTORY_TOKEN="$ARTIFACTORY_TOKEN" ARTIFACTORY_USER="$ARTIFACTORY_USER" TANZU_SM_VERSION="$TANZU_SM_VERSION" bash -s' < tp-install-jumpbox.sh