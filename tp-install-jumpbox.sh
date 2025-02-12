#!/bin/bash

set -x
set -eo pipefail

artifactory_token=$(echo $SUPPORT_PORTAL_TOKEN | jq -r .access_token)
installer_download_url="https://packages.broadcom.com/artifactory/tanzu-platform-sm/hub-self-managed/$TANZU_SM_VERSION/installer/tanzu-self-managed-$TANZU_SM_VERSION-linux-amd64.tar.gz"
curl -L -u ${ARTIFACTORY_USER}:${artifactory_token} ${installer_download_url} --output tanzu-self-managed-${TANZU_SM_VERSION}.tar.gz
mkdir tpsm && tar -xzf tanzu-self-managed-${TANZU_SM_VERSION}.tar.gz -C ./tpsm
rm tanzu-self-managed-${TANZU_SM_VERSION}.tar.gz

kubectl ctx $(yq eval '.current-context' tpsm.kubeconfig)
docker_registry=tanzu-platform-sm.packages.broadcom.comexport
./tanzu-sm-installer install -f config.yaml -u "${ARTIFACTORY_USER}:${artifactory_token}" -r ${docker_registry}/hub-self-managed/${TANZU_SM_VERSION}/repo --install-version ${TANZU_SM_VERSION} --kubeconfig ${KUBECONFIG}