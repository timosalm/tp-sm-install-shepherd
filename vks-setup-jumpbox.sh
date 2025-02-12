#!/bin/bash

set -x
set -eo pipefail

mkdir -p $HOME/.kube
echo "alias k=kubectl" >> ~/.bashrc

git clone https://github.com/BrianRagazzi/EPC-shepherd-tpsm

sudo sed -i 's|http_port 3128|http_port 443|g' /etc/squid/squid.conf
sudo systemctl restart squid

./EPC-shepherd-tpsm/resources/dnsmasq-install.sh
echo 'address=/tanzu.platform.io/192.168.116.206' | sudo tee -a /etc/dnsmasq.d/vlan-dhcp-dns.conf
echo 'address=/harbor.platform.io/192.168.116.1' | sudo tee -a /etc/dnsmasq.d/vlan-dhcp-dns.conf
sudo systemctl restart dnsmasq

mkdir -p build/
curl -kL https://carvel.dev/install.sh | K14SIO_INSTALL_BIN_DIR=build bash
sudo cp -r ./build/* /usr/local/bin/

sudo apt install -y ca-certificates curl gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://storage.googleapis.com/tanzu-cli-installer-packages/keys/TANZU-PACKAGING-GPG-RSA-KEY.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-installer-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list
sudo apt update
sudo apt install -y tanzu-cli

wget https://github.com/vmware-tanzu/crash-diagnostics/releases/download/v0.3.10/crashd_0.3.10_linux_amd64.tar.gz
mkdir -p crashd_0.3.10_linux_amd64
tar -xvf crashd_0.3.10_linux_amd64.tar.gz -C crashd_0.3.10_linux_amd64
sudo mv crashd_0.3.10_linux_amd64/crashd  /usr/local/bin/crashd

sudo mv om /usr/local/bin/om
sudo chmod +x om

( \
  set -x; cd "$(mktemp -d)" && \
  OS="$(uname | tr '[:upper:]' '[:lower:]')" && \
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" && \
  KREW="krew-${OS}_${ARCH}" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" && \
  tar zxvf "${KREW}.tar.gz" && \
  ./"${KREW}" install krew \
)
echo "export PATH=\"${KREW_ROOT:-$HOME/.krew}/bin:$PATH\"" >> ${HOME}/.bashrc
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
kubectl krew install ctx
kubectl krew install ns
kubectl krew install konfig
echo "alias k=kubectl" >> ${HOME}/.bashrc

sudo snap install yq

kubectl apply -f EPC-shepherd-tpsm/resources/vmclass-tpsm.yaml -n testns

kubectl apply -f EPC-shepherd-tpsm/resources/cluster-tpsm.yaml -n testns
kubectl wait --for=condition=ready --timeout=1h tanzukubernetescluster tpsm -n testns
kubectl get secret tpsm-kubeconfig -n testns -ojsonpath='{.data.value}' | base64 -d > tpsm.kubeconfig
kubectl konfig import --save tpsm.kubeconfig