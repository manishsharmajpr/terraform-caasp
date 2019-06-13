# terraform-caasp

ssh-keygen

ssh-copy-id sles@caasp-node-0
ssh-copy-id sles@caasp-node-1
ssh-copy-id sles@caasp-node-2

eval "$(ssh-agent -s)"

ssh-add

caaspctl cluster init --control-plane $(hostname -f) my-cluster

cd my-cluster

caaspctl node bootstrap --user sles --sudo --target $(hostname -f) master

caaspctl node join --role worker --user sles --sudo --target caasp-node-1 worker-1

caaspctl node join --role worker --user sles --sudo --target caasp-node-2 worker-2

kubectl --kubeconfig ./admin.conf get nodes

kubectl --kubeconfig ./admin.conf get pods --all-namespaces
