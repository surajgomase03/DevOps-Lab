#!/bin/bash
# Deployment Basic Commands

echo "=== Create Deployment Imperatively ==="
kubectl create deployment nginx-deploy --image=nginx --replicas=3 -n dev

echo "=== Verify Deployment ==="
kubectl get deploy -n dev
kubectl get pods -n dev
kubectl get rs -n dev

echo "=== Get Deployment Details ==="
kubectl describe deployment nginx-deploy -n dev

echo "=== Apply from YAML ==="
kubectl apply -f deployment-basic.yaml

echo "=== Update Deployment Image (Rolling Update) ==="
kubectl set image deployment/nginx-deploy nginx=nginx:1.25 -n dev --record

echo "=== Watch Rollout ==="
kubectl rollout status deployment/nginx-deploy -n dev

echo "=== View Rollout History ==="
kubectl rollout history deployment/nginx-deploy -n dev

echo "=== Cleanup ==="
# kubectl delete deployment nginx-deploy -n dev
