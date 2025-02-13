## Prerequisites
- Clone this repository on your local machine and change the directory to it
- Install ssh-pass on local machine
  ```
  # ubuntu/debian
  apt install sshpass
  # macOS
  brew install sshpass
  ```
- Install sheperd, and sheepctl CLIs on your local machine
  Ensure you have an SSH key configured for https://github.gwd.broadcom.net.
  ```
  ssh-add ~/.ssh/my-broadcom-github-ssh-key
  brew tap vmware/internal git@github.gwd.broadcom.net:TNZ/shepherd-homebrew-internal.git  

  # If you already have a vmware/internal tap
  brew tap vmware/internal --custom-remote git@github.gwd.broadcom.net:TNZ/shepherd-homebrew-internal.git

  brew install sheepctl
  brew install shepherd # Run "brew uninstall shepherd" before if you have installed it

  sheepctl target set -u https://epc-shepherd.lvn.broadcom.net -n Tanzu-Sales
  ```

## Getting Started
```
sheepctl lock list -n Tanzu-Sales
export LOCKID=<lock-id-for-the-regions-env>
./get-logins.sh
```

## Firefox Proxy Setup
Follow instructions [here](https://github.com/BrianRagazzi/EPC-shepherd-tpsm/blob/main/tpsm-install.md#configure-firefox-to-use-proxy---necessary-to-reach-vcenter-and-tpsm
)

## Supervisor Workload Network Config Validation
Even if it's probably everything configured correctly, follow instructions [here](https://github.com/BrianRagazzi/EPC-shepherd-tpsm/blob/main/tpsm-install.md#verify-supervisor-workload-network-config)


## VKS Setup
```
./vks-setup.sh
```

## TP SM Install
```
export ARTIFACTORY_USER=ts024828 # Okta user without @broadcom.net
export ARTIFACTORY_TOKEN=cmVmdG... # Token from Artifactory instance https://usw1.packages.broadcom.com
export TANZU_SM_VERSION=10.0.0-oct-2024-rc.533-vc0bb325
./tp-install
```
