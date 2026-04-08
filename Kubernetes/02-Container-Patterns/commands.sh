#!/bin/bash
# Container Patterns Commands

echo "=== 1. Deploy Init Container Pod ==="
kubectl apply -f 01-init-container.yaml
sleep 3
kubectl get pods -n dev
kubectl describe pod pod-with-init -n dev
kubectl logs pod-with-init -n dev

echo "=== 2. Deploy Sidecar Container Pod ==="
kubectl apply -f 02-sidecar-container.yaml
sleep 3
kubectl get pods -n dev
kubectl logs pod-with-sidecar -n dev -c sidecar-logger

echo "=== 3. Deploy Ambassador Container Pod ==="
kubectl apply -f 03-ambassador-container.yaml
sleep 3
kubectl get pods -n dev
kubectl logs pod-with-ambassador -n dev -c ambassador-proxy

echo "=== 4. Deploy ALL PATTERNS Combined ==="
kubectl apply -f 04-all-patterns-combined.yaml
sleep 3
kubectl get pods -n dev -l app=production-app
kubectl describe pod app-with-all-sidecars -n dev

echo "=== View Logs by Container ==="
kubectl logs app-with-all-sidecars -n dev -c app
kubectl logs app-with-all-sidecars -n dev -c sidecar-logger
kubectl logs app-with-all-sidecars -n dev -c sidecar-metrics
kubectl logs app-with-all-sidecars -n dev -c ambassador-proxy

echo "=== Cleanup ==="
# kubectl delete pod pod-with-init pod-with-sidecar pod-with-ambassador app-with-all-sidecars -n dev
