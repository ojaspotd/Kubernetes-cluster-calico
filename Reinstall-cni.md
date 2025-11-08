**Uninstall CNI using the yaml file used to create it**
```
kubectl delete -f custom-resources.yaml
```
**Remove CNI files**
```
cd /etc/cni/net.d/
rm -rf *.conflist *.kubeconfig
```
**Restart the container runtime and kubelet**
```
systemctl restart crio kubelet
```
**Install your required CNI**
```
kubectl create -f canal.yaml
```
