# Certified Kubernetes Application Developer

## Tips

1. CKAD Exam tips for shortcut

```bash
#!/bin/bash
alias k=kubectl # will already be pre-configured
export do="--dry-run=client -o yaml" # k create deploy nginx --image=nginx $do
export now="--force --grace-period 0" # k delete pod x $now
```

## Pods

### Template

1. Pod template

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
spec:
  containers:
    - image: httpd:2.4.41-alpine
      name: pod1-container # change
      resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

2. Pod with secret

- [Reference for secret volume](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Reference for secret environment](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#define-container-environment-variables-using-secret-data)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: secret-handler
    uuid: 1428721e-8d1c-4c09-b5d6-afd79200c56a
    red_ident: 9cf7a7c0-fdb2-4c35-9c13-c2a0bb52b4a9
    type: automatic
  name: secret-handler
spec:
  volumes:
    - name: cache-volume1
      emptyDir: {}
    - name: cache-volume2
      emptyDir: {}
    - name: cache-volume3
      emptyDir: {}
    - name: secret2-volume # add
      secret: # add
        secretName: secret2 # add
  containers:
    - name: secret-handler
      image: bash:5.0.11
      args: ["bash", "-c", "sleep 2d"]
      volumeMounts:
        - mountPath: /cache1
          name: cache-volume1
        - mountPath: /cache2
          name: cache-volume2
        - mountPath: /cache3
          name: cache-volume3
        - name: secret2-volume # add
          mountPath: /tmp/secret2 # add
      env:
        - name: SECRET_KEY_1
          value: ">8$kH#kj..i8}HImQd{"
        - name: SECRET_KEY_2
          value: "IO=a4L/XkRdvN8jM=Y+"
        - name: SECRET_KEY_3
          value: "-7PA0_Z]>{pwa43r)__"
        - name: SECRET1_USER # add
          valueFrom: # add
            secretKeyRef: # add
              name: secret1 # add
              key: user # add
        - name: SECRET1_PASS # add
          valueFrom: # add
            secretKeyRef: # add
              name: secret1 # add
              key: pass # add
```

3. Pod with readiness

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod6
  name: pod6
spec:
  containers:
    - command:
        - sh
        - -c
        - touch /tmp/ready && sleep 1d
      image: busybox:1.31.0
      name: pod6
      resources: {}
      readinessProbe: # add
        exec: # add
          command: # add
            - sh # add
            - -c # add
            - cat /tmp/ready # add
        initialDelaySeconds: 5 # add
        periodSeconds: 10 # add
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```

### Others commands

1. Get status

   `kubectl get pod <pod_name> -o jsonpath="{.status.phase}"`

2. Show labels

   `kubectl get pod --show-labels`

3. Show certain labels

   `kubectl get pod -l <key>=<value>`

4. Label pod

   `kubectl label pod -l <key>=<value> <new_key>=<new_value>`

5. Annotate pod

   `kubectl annotate pod -l <key>=<value> <new_key>=<new_value>`

### Imperative commands

1. Create a `nginx` pod:

   `kubectl run <pod_name> --image=nginx`

2. Generate a pod YAML

   `kubectl run <pod_name> --image=nginx --dry-run=client -o yaml`

3. Generate a pod with command

   `kubectl run <pod_name> --image=busybox:1.31.0 --command -- sh -c "touch /tmp/ready && sleep 1d"`

4. Generate a pod with labels

   `kubectl run  <pod_name> --image=nginx:1.17.3-alpine --labels <key>=<value>`

## ReplicaSets

## Deployments

### Template

1. deployment template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: holy-api # name stays the same
spec:
  replicas: 3 # 3 replicas
  selector:
    matchLabels:
      id: holy-api # set the correct selector
  template:
    # => from here down its the same as the pods metadata: and spec: sections
    metadata:
      labels:
        id: holy-api
      name: holy-api
    spec:
      containers:
        - env:
            - name: CACHE_KEY_1
              value: b&MTCi0=[T66RXm!jO@
            - name: CACHE_KEY_2
              value: PCAILGej5Ld@Q%{Q1=#
            - name: CACHE_KEY_3
              value: 2qz-]2OJlWDSTn_;RFQ
          image: nginx:1.17.3-alpine
          name: holy-api-container
          securityContext: # add
            allowPrivilegeEscalation: false # add
            privileged: false # add
          volumeMounts:
            - mountPath: /cache1
              name: cache-volume1
            - mountPath: /cache2
              name: cache-volume2
            - mountPath: /cache3
              name: cache-volume3
      volumes:
        - emptyDir: {}
          name: cache-volume1
        - emptyDir: {}
          name: cache-volume2
        - emptyDir: {}
          name: cache-volume3
```

2. with volumes

- [Reference for pvc](https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolumeclaim)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: project-earthflower
  name: project-earthflower
spec:
  replicas: 1
  selector:
    matchLabels:
      app: project-earthflower
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: project-earthflower
    spec:
      volumes: # add
        - name: data # add
          persistentVolumeClaim: # add
            claimName: earth-project-earthflower-pvc # add
      containers:
        - image: httpd:2.4.41-alpine
          name: container
          volumeMounts: # add
            - name: data # add
              mountPath: /tmp/project-data # add
```

3. sidecar container template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  name: cleaner
  namespace: mercury
spec:
  replicas: 2
  selector:
    matchLabels:
      id: cleaner
  template:
    metadata:
      labels:
        id: cleaner
    spec:
      volumes:
        - name: logs
          emptyDir: {}
      initContainers:
        - name: init
          image: bash:5.0.11
          command: ["bash", "-c", "echo init > /var/log/cleaner/cleaner.log"]
          volumeMounts:
            - name: logs
              mountPath: /var/log/cleaner
      containers:
        - name: cleaner-con
          image: bash:5.0.11
          args:
            [
              "bash",
              "-c",
              'while true; do echo `date`: "remove random file" >> /var/log/cleaner/cleaner.log; sleep 1; done',
            ]
          volumeMounts:
            - name: logs
              mountPath: /var/log/cleaner
        - name: logger-con # add
          image: busybox:1.31.0 # add
          command: ["sh", "-c", "tail -f /var/log/cleaner/cleaner.log"] # add
          volumeMounts: # add
            - name: logs # add
              mountPath: /var/log/cleaner # add
```

4. init container template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
        - name: web-content
          emptyDir: {}
      initContainers: # initContainer start
        - name: init-con
          image: busybox:1.31.0
          command:
            ["sh", "-c", 'echo "check this out!" > /tmp/web-content/index.html']
          volumeMounts:
            - name: web-content
              mountPath: /tmp/web-content # initContainer end
      containers:
        - image: nginx:1.17.3-alpine
          name: nginx
          volumeMounts:
            - name: web-content
              mountPath: /usr/share/nginx/html
          ports:
            - containerPort: 80
```

5. memory request and limit template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: neptune-10ab
  name: neptune-10ab
  namespace: neptune
spec:
  replicas: 3 # change
  selector:
    matchLabels:
      app: neptune-10ab
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: neptune-10ab
    spec:
      serviceAccountName: neptune-sa-v2 # add
      containers:
        - image: httpd:2.4-alpine
          name: neptune-pod-10ab # change
          resources: # add
            limits: # add
              memory: 50Mi # add
            requests: # add
              memory: 20Mi # add
status: {}
```

### Rollout

1. History

   `kubectl rollout history`

2. Rollout

   `kubectl rollout undo deploy api-new-c32`

### Imperative commands

1. Create a deployment

   `kubectl create deployment --image=nginx nginx`

2. Generate a deployment YAML

   `kubectl create deployment --image=nginx nginx --dry-run -o yaml`

3. Generate Deployment with 4 Replicas

   `kubectl create deployment nginx --image=nginx --replicas=4`

4. Scale deployment

   `kubectl scale deployment nginx --replicas=4`

## Job

### Templates

1.  Job Templates

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: neb-new-job
  namespace: neptune # add
spec:
  completions: 3 # add
  parallelism: 2 # add
  template:
    metadata:
      creationTimestamp: null
      labels: # add
        id: awesome-job # add
    spec:
      containers:
        - command:
            - sh
            - -c
            - sleep 2 && echo done
          image: busybox:1.31.0
          name: neb-new-job-container # update
          resources: {}
      restartPolicy: Never
status: {}
```

### Imperative commands

1. Create a job

   `kubectl create job <job_name> --image=busybox:1.31.0 `

## Namespaces

## Services

### Templates

1. Node port Template

```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc
spec:
  clusterIP: 10.3.245.70
  ports:
    - name: 8080-80
      port: 8080
      protocol: TCP
      targetPort: 80
      nodePort: 30100 # add the nodePort
  selector:
    id: svc
  sessionAffinity: None
  #type: ClusterIP
  type: NodePort # change type
status:
  loadBalancer: {}
```

### Imperative commands

1. Create a Service named redis-service of type ClusterIP to expose pod redis on port 6379

   a. Automatically use the pod's labels as selectors

   `kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml`

   b. Not use the pods' labels as selectors; instead it will assume selectors as app=redis. if your pod has a different label set, and you should generate the file and modify the selectors before creating the service

   `kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml`

2. Create a Service of type NodePort to expose pod nginx's port 80 on port 30080 on the nodes:

   a. Automatically use the pod's labels as selectors, but you cannot specify the node port

   `kubectl expose pod nginx --port=80 --name nginx-service --type=NodePort --dry-run=client -o yaml`

   b. Not use the pods' labels as selectors

   `kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml`

## Ingress

## Network Policy

### Template

1. podSelector network policy example

- [Reference for network policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np
spec:
  podSelector:
    matchLabels:
      id: frontend # label of the pods this policy should be applied on
  policyTypes:
    - Egress # we only want to control egress
  egress:
    - to: # 1st egress rule
        - podSelector: # allow egress only to pods with api label
            matchLabels:
              id: api
    - ports: # 2nd egress rule
        - port: 53 # allow DNS UDP
          protocol: UDP
        - port: 53 # allow DNS TCP
          protocol: TCP
```

## Persistent Volumes

### Template

1. PV Template

```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: earth-project-earthflower-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"
```

## Persistent Volumes Claim

### Template

1. PVC

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: earth-project-earthflower-pvc
  namespace: earth
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

## Storage class

### Template

1.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: moon-retain
provisioner: moon-retainer
reclaimPolicy: Retain
```

## Environment

## ConfigMap

### Imperative commands

1. Create configMap from literal

   `kubectl create cm cm --from-literal=name=shannon --from-literal=config=map`

2. Create configMap from file
   `kubectl create configmap cm --from-file=index.html=/opt/course/15/web-moon.html`

## Secrets

### Other commands

1.  Decode secret

    `kubectl get secrets/db-user-pass --template={{.data.password}} | base64 -D`

### Imperative commands

1. Create generic secret

   `kubectl create secret generic db-secret  --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123`

## Security Context

## Taints and Tolerations

## Node Selectors

## Node Affinity

## Logging

## Metrics

## Helm

1. List releases

   list deployed `helm -n mercury ls`

   list all `helm -n mercury ls -a`

2. Install new release with value

   `helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2`

3. Delete the required release

   `helm -n mercury uninstall internal-issue-report-apiv1`

4. Upgrade release

   `helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx`

5. List repo

   `helm repo list`

6. Update repo

   `helm repo update`

7. Search chart

   `helm search repo nginx`

8. Show value

   `helm show values bitnami/apache`

## Resources

1. [Udemy CKAD course](https://www.udemy.com/course/certified-kubernetes-application-developer/)
2. [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
3. [Kubernetes Tasks](https://kubernetes.io/docs/tasks/)
4. [Kubernetes Cheatsheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
