#!/bin/bash
# Interview Question Practice Commands

echo "=== QUESTION 1: Zero Downtime Strategy ==="
kubectl set image deployment/myapp myapp=myapp:v2 --record -n dev
kubectl rollout status deployment/myapp -n dev
kubectl get pods -w -n dev

echo ""
echo "=== QUESTION 2: Debugging Stuck Deployment ==="
kubectl rollout status deployment/myapp -n dev
kubectl get pods -n dev
kubectl describe pod <pod-name> -n dev
kubectl get events --sort-by=.metadata.creationTimestamp -n dev
kubectl describe deployment myapp -n dev
kubectl logs <pod-name> -n dev

echo ""
echo "=== QUESTION 3: Rollback Scenario ==="
kubectl rollout undo deployment/myapp -n dev
kubectl rollout status deployment/myapp -n dev
kubectl rollout history deployment/myapp -n dev
kubectl rollout undo deployment/myapp --to-revision=1 -n dev

echo ""
echo "=== QUESTION 4: maxSurge vs maxUnavailable ==="
kubectl apply -f ../04-Rolling-Update-Strategies/01-strategy-zero-downtime.yaml
kubectl set image deployment/nginx-zero-downtime nginx=nginx:1.25 -n dev
kubectl get pods -w -n dev

echo ""
echo "=== QUESTION 5: Init Container DB Check ==="
# Create deployment with init container that waits for DB
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-init
  namespace: dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      initContainers:
      - name: wait-for-db
        image: busybox
        command: ['sh', '-c', 'until nc -z db.default.svc.cluster.local 5432; do echo "Waiting for DB..."; sleep 2; done']
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
EOF

echo ""
echo "=== QUESTION 6: Label Filtering ==="
# Prod + web tier
kubectl get pods -l env=prod,tier=web -A -n dev

# Prod, exclude API
kubectl get pods -l env=prod,app!=api -A -n dev

# Complex filtering
kubectl get pods -l env=prod -A -n dev | grep -E 'web|frontend'

echo ""
echo "=== QUESTION 7: Revision History ==="
kubectl rollout history deployment/nginx-zero-downtime -n dev
kubectl rollout history deployment/nginx-zero-downtime -n dev --revision=1
kubectl rollout undo deployment/nginx-zero-downtime -n dev --to-revision=1

echo ""
echo "=== QUESTION 8: Real-Time Pod Watch ==="
echo "Run in separate terminal:"
echo "kubectl get pods -w -n dev"
echo "kubectl get pods -w -l app=nginx -n dev"

echo ""
echo "=== QUESTION 9: Emergency Rollback ==="
kubectl rollout undo deployment/nginx-zero-downtime -n dev
kubectl get pods -n dev
kubectl rollout status deployment/nginx-zero-downtime -n dev

echo ""
echo "=== QUESTION 10: Pod Resource Issue ==="
kubectl describe pod <pod-name> -n dev
kubectl describe nodes
kubectl top nodes
kubectl describe deployment nginx-zero-downtime -n dev | grep -A5 requests
