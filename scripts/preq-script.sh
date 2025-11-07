#/bin/bash

#Update the apt 
sudo apt-get update

# Install required tools
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# Get the GPG key for the k8s repository 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.34/deb/Release.key|sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

# Add the repo for the command to the apt source:
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.34/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

#Update the apt 
sudo apt-get update

# Install the packages:
sudo apt-get install -y cri-o kubelet kubeadm kubectl

# Swap needs to be turned off.
sudo swapoff -a

# Start the crio service:
sudo systemctl start crio.service

# Enable IPv4 packet forward kernel parameter.
sudo sysctl -w net.ipv4.ip_forward=1

# Enable bridge netfilter
sudo modprobe br_netfilter
