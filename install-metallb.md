**Install Metallb**
```
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.2/config/manifests/metallb-native.yaml
```

**Create the IPPOOL**
```
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: cheap
  namespace: metallb-system
spec:
  addresses:
  - 172.168.10.0/24
EOF
ipaddresspool.metallb.io/cheap created
```

**Create L2 advertisment**
```
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: default
  namespace: metallb-system
EOF
```

* Create a Loadbalancer service type and verify external IP address is populated.
