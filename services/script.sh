# set env
alias k=kubectl
export do="--dry-run=client -o yaml"

# create pod template
k expose pod web-page --port=80 --name web-page-svc $do > example/pod-cluster-ip-svc.yaml
# create deployment template
k expose deployment frontend-deploy --type=NodePort --port=80 --name frontend-deploy-svc $do > example/deployment-node-port-svc.yaml
