#!/bin/bash

set -x
set -eo pipefail

export TANZU_NET_TOKEN=
export TANZU_SM_VERSION=1.1.0
sshpass -p $jumpbox_password ssh kubo@$jumpbox_ip 'TANZU_NET_TOKEN="$TANZU_NET_TOKEN" TANZU_SM_VERSION="$TANZU_SM_VERSION" bash -s' < tp-install-jumpbox.sh