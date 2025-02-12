#!/bin/bash

set -eo pipefail

lock_info=$(sheepctl lock get ${LOCKID} -j)

echo "Jumpbox ip: $(jq -r .outputs.vm.jumper.hostname <<< $lock_info) user: $(jq -r .outputs.vm.jumper.username <<< $lock_info) password: $(jq -r .outputs.vm.jumper.password <<< $lock_info)"
echo "SSH into Jumpbox: ssh $(jq -r .outputs.vm.jumper.username <<< $lock_info)@$(jq -r .outputs.vm.jumper.hostname <<< $lock_info)"

echo "vCenter URL: https://$(jq -r '.outputs.vm["vc.0"].hostname' <<< $lock_info) user: administrator@vsphere.local password: $(jq -r '.outputs.vm["vc.0"].password' <<< $lock_info)"