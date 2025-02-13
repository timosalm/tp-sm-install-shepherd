#!/bin/bash

set -x
set -eo pipefail

installer_download_url="https://packages.broadcom.com/artifactory/tanzu-platform-sm/hub-self-managed/$TANZU_SM_VERSION/installer/tanzu-self-managed-$TANZU_SM_VERSION-linux-amd64.tar.gz"
curl -L -u ${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN} ${installer_download_url} --output tanzu-self-managed-${TANZU_SM_VERSION}.tar.gz
mkdir tpsm && tar -xzf tanzu-self-managed-${TANZU_SM_VERSION}.tar.gz -C ./tpsm
rm tanzu-self-managed-${TANZU_SM_VERSION}.tar.gz

kubectl ctx $(yq eval '.current-context' tpsm.kubeconfig)

kubectl apply -f EPC-shepherd-tpsm/resources/storageclass-tpsm.yaml
kapp deploy --yes --wait --wait-check-interval 10s --app cert-manager --file https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml

sed -i 's|profile: foundation|profile: evaluation|' tpsm/config.yaml
sed -i 's|loadBalancerIP: ""|loadBalancerIP: "192.168.116.206"|' tpsm/config.yaml
sed -i 's|host: ""|host: "tanzu.platform.io"|' tpsm/config.yaml
sed -i 's|storageClass: ""|storageClass: "tpsm"|g' tpsm/config.yaml
sed -i '42 s|allowInsecureConnections: false|allowInsecureConnections: true|' tpsm/config.yaml
sed -i ' 80 s|password: ""|password: "admin123"|' tpsm/config.yaml
sed -i ' 153 s|name: ""|name: "tanzu-sales"|' tpsm/config.yaml
sed -i 's|#  oauthProviders:|  oauthProviders:|g' tpsm/config.yaml
sed -i ' 92 s|#    - name: ""|    - name: "okta.test"|' tpsm/config.yaml
sed -i ' 97 s|#      configUrl: ""|      configUrl: "https://dev-70846880.okta.com/.well-known/openid-configuration"|'  tpsm/config.yaml
sed -i ' 99 s|#      issuerUrl: ""|      issuerUrl: "https://dev-70846880.okta.com"|' tpsm/config.yaml
sed -i ' 101 s|#      scopes: \["openid"]|      scopes: \["openid", "email", "groups"]|' tpsm/config.yaml
sed -i ' 103 s|#      loginPageLinkText: ""|      loginPageLinkText: "Login with Dev Okta"|'  tpsm/config.yaml
sed -i ' 105 s|#      clientId: ""|      clientId: "0oaggqbiqdlnTtfFY5d7"|'  tpsm/config.yaml
sed -i ' 107 s|#      secret: ""|      secret: "UMdEVboJTSfHAQEbuIlj1j2zticsxBRiEuRLYsfJk6dbeR9Nh47qH_7E_7q7MVT1"|' tpsm/config.yaml
sed -i ' 109 s|#      attributeMappings:|      attributeMappings:|' tpsm/config.yaml
sed -i ' 111 s|#        username: ""|        username: "email"|' tpsm/config.yaml
sed -i ' 113 s|#        groups: ""|        groups: "groups"|' tpsm/config.yaml

docker_registry=tis-tanzuhub-sm-docker-dev-local.usw1.packages.broadcom.com
(cd tpsm && ./tanzu-sm-installer verify -f config.yaml -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" -r ${docker_registry}/hub-self-managed/${TANZU_SM_VERSION}/repo --install-version ${TANZU_SM_VERSION})
(cd tpsm && ./tanzu-sm-installer install -f config.yaml -u "${ARTIFACTORY_USER}:${ARTIFACTORY_TOKEN}" -r ${docker_registry}/hub-self-managed/${TANZU_SM_VERSION}/repo --install-version ${TANZU_SM_VERSION})