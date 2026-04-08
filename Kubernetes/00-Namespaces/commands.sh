#!/bin/bash
# Create Namespaces Commands

echo "=== Creating Namespaces ==="

# Method 1: Imperative
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod

# Method 2: Declarative
# kubectl apply -f create-namespaces.yaml

# Verify
echo "=== Verifying Namespaces ==="
kubectl get ns
