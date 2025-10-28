# Kubernetes-cluster-calico

<img width="761" height="481" alt="local-k8s-cluster" src="https://github.com/user-attachments/assets/9e9a1d44-2be6-4ba6-a518-bd73f4f3a3de" />

# Create Virtual Machine

Used multipass to create virtual machine.

**Ubuntu 24.04 LTS version:**
  ```
  multipass launch --name workernode1 --cpus 2 --memory 2G --disk 10G --network "en0" lts
  multipass launch --name workernode2 --cpus 2 --memory 2G --disk 10G --network "en0" lts
  ```
**Prequisities:**
* Kubeadm - Tool to setup K8s cluster.
* kubelet - Process that runs on every node that send information to API server and start controlplane node components
* Kubectl - Command to communicate with the cluster.
* Container runtime - This will spawn the control plane components in pod and application pods on worker nodes.


**Install required tools**
  ```
  sudo apt-get install -y apt-transport-https ca-certificates curl gpg
  ```
**Download GPG key for Kubernetes and crio package repositories**
  ```
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    curl -fsSL https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.34/deb/Release.key|sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
  ```
**Add the Kubernetes and crio package repositories to the apt source:**
  ```
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://download.opensuse.org/repositories/isv:/cri-o:/stable:/v1.34/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list
  ```
**Update and install the packages**
  ```  
  sudo apt-get update
  sudo apt-get install -y cri-o kubelet kubeadm kubectl
  ```


**Prechecks and settings:**
* The nodes participating in a cluster requires unique mac address which can be checked via following command:
  ```
  ip link
  ifconfig -a
  ```
* Swap needs to be turned off.
  ```
		sudo swapoff -a
  ```
* Start the crio service:
  ```
		sudo systemctl start crio.service
  ```
* Enable IPv4 packet forward kernel parameter.
  ```
		sudo sysctl -w net.ipv4.ip_forward=1
  ```
* Enable bridge netfilter
  ```
		sudo modprobe br_netfilter
  ```

**Installing Calico**

On the controlplane node run the following:

* Install the Calico operator crds and the Tigera operater. Tigera operator will help to administer calico.
  ```
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/operator-crds.yaml
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/tigera-operator.yaml
  ```
* Deploy Calico, edit custom-resources.yaml to have ippools.cidr match cluster cluster-pod-cidr value.
  ```
  curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.31.0/manifests/custom-resources.yaml
  kubectl create -f custom-resources.yaml
  ```
* Run the following command to check the status:
  ```
  watch kubectl get tigerastatus
  ```

