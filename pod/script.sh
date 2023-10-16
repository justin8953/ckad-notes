# set env
alias k=kubectl
export do="--dry-run=client -o yaml"

# create pod template
k run --image=busybox:1.31.0 pod $do > example/pod.yaml
# create pod with command template
k run --image=busybox:1.31.0 pod $do --command -- sh -c "sleep 2000" > example/pod-command.yaml

