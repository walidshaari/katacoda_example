#!/bin/bash


sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
ocho "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

ssh node01 "sudo apt-get update &&  sudo apt-get install -y apt-transport-https ca-certificates curl"
ssh node01 'echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list'
ssh node01 'sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg'

echo "******* 1/2 Upgrading cluster to v.1.19 *******"

kubeadm config images pull --kubernetes-version 1.19.0 > /dev/null 2>&1

apt-get update -y > /dev/null 2>&1 && apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00 > /dev/null 2>&1
kubeadm upgrade apply v1.19.0 --yes --ignore-preflight-errors=all > /dev/null 2>&1

ssh node01 'apt-get update -y > /dev/null 2>&1 && apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00 > /dev/null 2>&1'
ssh node01 'sudo kubeadm upgrade node' > /dev/null 2>&1

apt-get install -y kubelet=1.19.0-00 kubectl=1.19.0-00 > /dev/null 2>&1

sleep 15

echo "******* 2/2  Upgrading cluster to v.1.20 *******"

kubeadm config images pull --kubernetes-version 1.20.4 > /dev/null 2>&1

sudo apt-get update -y > /dev/null 2>&1 && sudo apt-get install -y --allow-change-held-packages kubeadm=1.20.4-00 > /dev/null 2>&1
sudo kubeadm upgrade apply v1.20.4 --yes --ignore-preflight-errors=all > /dev/null 2>&1

ssh node01 'sudo apt-get update -y > /dev/null 2>&1 && sudo apt-get install -y --allow-change-held-packages kubeadm=1.20.4-00 > /dev/null 2>&1'
ssh node01 'sudo kubeadm upgrade node' > /dev/null 2>&1

sudo apt-get install -y kubelet=1.20.4-00 kubectl=1.20.4-00 > /dev/null 2>&1

sleep 15

echo "-*-*-*-  Cluster v1.20.4 Ready -*-*-*"
