# terraform-caasp

Fetch SLES15-SP1-JeOS.x86_64-15.1-OpenStack-Cloud-GMC3.qcow2 from:

```
https://download.suse.com/Download?buildid=JOZpKbnuAuw~
```

Log into caasp-node-0 as a user "sles".

1. Generate ssh-key.

```
ssh-keygen
```

2. Copy ssh-key to another nodes.

```
ssh-copy-id sles@caasp-node-0
ssh-copy-id sles@caasp-node-1
ssh-copy-id sles@caasp-node-2
```

3. Setup ssh-agent.

```
eval "$(ssh-agent -s)"
ssh-add
```

4. Initialize the cluster.

```
caaspctl cluster init --control-plane $(hostname -f) my-cluster
```

5. Switch to the new directory.

```
cd my-cluster

```

6. Bootstrap a master node.


```
caaspctl node bootstrap --user sles --sudo --target $(hostname -f) master
```

7. Add workers to the cluster.

```
caaspctl node join --role worker --user sles --sudo --target caasp-node-1 worker-1

caaspctl node join --role worker --user sles --sudo --target caasp-node-2 worker-2
```

8. Verify cluster status and enjoy.

```
caaspctl cluster status

kubectl --kubeconfig ./admin.conf get nodes

kubectl --kubeconfig ./admin.conf get pods --all-namespaces
```
