#!/bin/bash
# Basic Pods Commands

echo "=== Create Pods Imperatively ==="
kubectl run pod1 --image=nginx -n dev
kubectl run pod2 --image=nginx -n dev
kubectl run pod3 --image=nginx -n staging
kubectl run pod4 --image=nginx -n prod
kubectl run pod5 --image=nginx -n prod

echo "=== Verify Pods ==="
kubectl get pods -A

echo "=== Add Labels ==="
kubectl label pod pod1 env=dev app=web tier=frontend -n dev
kubectl label pod pod2 env=dev app=api tier=backend -n dev
kubectl label pod pod3 env=staging app=web tier=frontend -n staging
kubectl label pod pod4 env=prod app=web tier=frontend -n prod
kubectl label pod pod5 env=prod app=api tier=backend -n prod

echo "=== Show All Labels ==="
kubectl get pods --show-labels -A

echo "=== FILTER: Get all dev pods ==="
kubectl get pods -l env=dev -A

echo "=== FILTER: Get all prod pods ==="
kubectl get pods -l env=prod -A

echo "=== FILTER: Get all web tier pods ==="
kubectl get pods -l tier=frontend -A

echo "=== FILTER: Get prod API pods ==="
kubectl get pods -l env=prod,app=api -A

echo "=== Create from YAML ==="
kubectl apply -f pod-with-labels.yaml

echo "=== Delete Pods ==="
# kubectl delete pod pod1 -n dev
# kubectl delete -f pod-with-labels.yaml
