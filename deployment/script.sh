# set env
alias k=kubectl
export do="--dry-run=client -o yaml"

# create deployment template with 3 replics
k create deployment --image=nginx --replicas=3 nginx $do > example/deployment-replicas.yaml

