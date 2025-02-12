#!/bin/bash

set -x
set -eo pipefail

om download-product -p tanzu-platform -o . --file-glob "*${TANZU_SM_VERSION}.tar.gz.part_aa" --product-version $TANZU_SM_VERSION --pivnet-api-token $TANZU_NET_TOKEN
om download-product -p tanzu-platform -o . --file-glob "*${TANZU_SM_VERSION}.tar.gz.part_ab" --product-version $TANZU_SM_VERSION --pivnet-api-token $TANZU_NET_TOKEN
om download-product -p tanzu-platform -o . --file-glob "*${TANZU_SM_VERSION}.tar.gz.part_ac" --product-version $TANZU_SM_VERSION --pivnet-api-token $TANZU_NET_TOKEN
om download-product -p tanzu-platform -o . --file-glob "*${TANZU_SM_VERSION}.tar.gz.part_ad" --product-version $TANZU_SM_VERSION --pivnet-api-token $TANZU_NET_TOKEN
om download-product -p tanzu-platform -o . --file-glob "*${TANZU_SM_VERSION}.tar.gz.sha256" --product-version $TANZU_SM_VERSION --pivnet-api-token $TANZU_NET_TOKEN

cat tanzu-self-managed-10.1.0.tar.gz.part_* > tanzu-self-managed-10.1.0.tar.gz
sha256sum -c tanzu-self-managed-10.1.0.tar.gz.sha256
rm tanzu-self-managed-10.1.0.tar.gz.*