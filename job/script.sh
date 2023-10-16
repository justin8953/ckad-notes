# set env
alias k=kubectl
export do="--dry-run=client -o yaml"

# create pod template
k create job --image=busybox:1.31.0 job $do > example/job.yaml
k create job --image=busybox:1.31.0 job $do -- sh -c "sleep 1000" > example/job-command.yaml