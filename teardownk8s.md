Uninstall K8s cluster created using kubeadm.

# Drain all the worker nodes
```
kubectl drain <workernode>
```

# Reset by running the following command on worker node
```
kubeadm reset
```

# Remove CNI configuration from the worker nodes
```
sudo rm -rf /etc/cni/net.d
```

# Remove the network traffic rules from the worker nodes
```
sudo apt install docker.io   #If docker is not installed.
sudo docker pull registry.k8s.io/kube-proxy:v1.34.0
sudo docker run --privileged --rm registry.k8s.io/kube-proxy:v1.34.0 sh -c "kube-proxy --cleanup && echo DONE"
I1107 14:29:54.578416       6 server_linux.go:53] "Using iptables proxy"
DONE
sudo apt remove docker.io
```

Perform same steps on the Master node.
