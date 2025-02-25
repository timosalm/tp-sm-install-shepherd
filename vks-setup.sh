#!/bin/bash

set -x
set -eo pipefail

rm -rf outputs && mkdir outputs

lock_info=$(sheepctl lock get ${LOCKID} -j)

jumpbox_ip=$(jq -r .outputs.vm.jumper.hostname <<< $lock_info)
jumpbox_user=$(jq -r .outputs.vm.jumper.username <<< $lock_info)
jumpbox_password=$(jq -r .outputs.vm.jumper.password <<< $lock_info)

sheepctl lock kubeconfig ${LOCKID} > outputs/supervisor.kubeconfig
sshpass -p $jumpbox_password scp -o StrictHostKeyChecking=accept-new outputs/supervisor.kubeconfig $jumpbox_user@$jumpbox_ip:/home/$jumpbox_user/.kube/config
wget https://github.com/pivotal-cf/om/releases/download/7.14.0/om-linux-amd64-7.14.0 && mv om-linux-amd64-7.14.0 om && sshpass -p $jumpbox_password scp om $jumpbox_user@$jumpbox_ip:/home/$jumpbox_user/

sshpass -p $jumpbox_password ssh $jumpbox_user@$jumpbox_ip 'bash -s' < vks-setup-jumpbox.sh
