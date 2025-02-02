#!/bin/bash -x
        
sudo apt update && sudo apt upgrade -y
cat <<EOF > /etc/sysctl.d/90-kubelet.conf
vm.overcommit_memory = 1
vm.panic_on_oom = 0
kernel.panic = 10
kernel.panic_on_oops = 1
kernel.keys.root_maxkeys = 1000000
kernel.keys.root_maxbytes = 25000000
EOF
sysctl -p /etc/sysctl.d/90-kubelet.conf

curl -sL https://releases.rancher.com/install-docker/19.03.sh | sh
sudo usermod -aG docker ubuntu

K8S_ROLES="--worker"

sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.5.5 --server https://<rancher_server_url> --token <token_value> --ca-checksum <ca_checksum_value> --address azpublic --internal-address azprivate ${K8S_ROLES}

