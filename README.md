# node-configuration-daemonset

This project shows how you can install the SSM agent onto EKS worker nodes using a Kubernetes DaemonSet.  This method for configuring the nodes can be used to customize workers in an EKS Managed Node Group (MNG) after they've been deployed, at least until launch templates are supported.  This project was heavily inspired by Shekhar Patnaik's [AKS Node Installer Project](https://github.com/patnaikshekhar/AKSNodeInstaller).  

## Installation instructions
1. Add the `AmazonSSMManagedInstanceCore` policy the the EC2 Instance Profile of the Managed Worker Nodes. 
2. Apply the ConfigMap:
```
kubectl apply -f configmap.yaml
```
3. Apply the DaemonSet: 
```
kubectl apply -f daemonset.yaml
```

## Updates
- 11/5/2020 The daemonset has been updated.  Instead of running indefinitely, the container that runs the scripts to install the SSM agent runs as an init container.  Upon exiting a `pause` container runs. This has a considerably smaller attack surface than the init container.   

## Verify installation
You can verify that the installation was successful by looking at the logs of a DaemonSet pod.  If the installation was successfull, the last line in the log file will read `Success` otherwise it will read `Fail`.  The nodes will also appears as managed instances in the SSM console if the installation was successful. 
