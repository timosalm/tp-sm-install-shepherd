## Prerequisites
- Install ssh-pass on local machine
```
# ubuntu/debian
apt install sshpass
# macOS
brew install sshpass
```

## Firefox Proxy Setup
```
./get-logins.sh
```

https://github.com/BrianRagazzi/EPC-shepherd-tpsm/blob/main/tpsm-install.md#configure-firefox-to-use-proxy---necessary-to-reach-vcenter-and-tpsm

## Supervisor Workload Network Config Validation
https://github.com/BrianRagazzi/EPC-shepherd-tpsm/blob/main/tpsm-install.md#verify-supervisor-workload-network-config

## VKS Setup
```
sheepctl lock list -n Tanzu-Sales
export LOCKID=
./vks-setup.sh
```

## TP SM Install
```
export SUPPORT_PORTAL_TOKEN='{"scope":"TNZ-PLATFORM-SM","access_token":"eyJ2ZXIiO...","expires_in":"15782400"}'
export ARTIFACTORY_USER=joe.doe@broadcom.com
export TANZU_SM_VERSION=10.0.0-oct-2024-rc.533-vc0bb325
./tp-install
```
