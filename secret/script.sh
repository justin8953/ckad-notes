# set env
alias k=kubectl
export do="--dry-run=client -o yaml"

# create pod template
k create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123 $do > example/secret-db.yaml