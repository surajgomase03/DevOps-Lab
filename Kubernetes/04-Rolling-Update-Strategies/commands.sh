#!/bin/bash
# Rolling Update Strategy Commands

echo "=== Strategy 1: Zero Downtime (Recommended) ==="
kubectl apply -f 01-strategy-zero-downtime.yaml
kubectl get deploy nginx-zero-downtime -n dev
kubectl get deploy nginx-zero-downtime -n dev -o yaml | grep -A5 strategy

echo ""
echo "=== Strategy 2: Faster Deployment ==="
kubectl apply -f 02-strategy-faster.yaml
kubectl get deploy nginx-faster -n dev -o yaml | grep -A5 strategy

echo ""
echo "=== Strategy 3: Aggressive ==="
kubectl apply -f 03-strategy-aggressive.yaml
kubectl get deploy nginx-aggressive -n dev -o yaml | grep -A5 strategy

echo ""
echo "=== Strategy 4: Percentage-Based ==="
kubectl apply -f 04-strategy-percentage.yaml
kubectl get deploy nginx-percentage -n dev -o yaml | grep -A5 strategy

echo ""
echo "=== Strategy 5: Recreate (No Rolling Update) ==="
kubectl apply -f 05-strategy-recreate.yaml
kubectl get deploy nginx-recreate -n dev -o yaml | grep -A5 strategy

echo ""
echo "============================================"
echo "TESTING: Perform Rolling Update"
echo "============================================"

echo ""
echo "=== Update nginx-zero-downtime ==="
kubectl set image deployment/nginx-zero-downtime nginx=nginx:1.25 -n dev --record
echo "Watch in real-time:"
echo "kubectl get pods -n dev -w"
echo "kubectl rollout status deployment/nginx-zero-downtime -n dev"

echo ""
echo "=== View Rollout History ==="
echo "kubectl rollout history deployment/nginx-zero-downtime -n dev"

echo ""
echo "=== Rollback to Previous Version ==="
echo "kubectl rollout undo deployment/nginx-zero-downtime -n dev"

echo ""
echo "=== Get Timeline of Update ==="
echo "kubectl describe deployment nginx-zero-downtime -n dev"

echo ""
echo "=== Simulate Bad Deployment ==="
echo "kubectl set image deployment/nginx-zero-downtime nginx=nginx:wrongtag -n dev --record"
echo "kubectl get pods -n dev  # Will show ImagePullBackOff"

echo ""
echo "=== Cleanup ==="
echo "kubectl delete deployment nginx-zero-downtime nginx-faster nginx-aggressive nginx-percentage nginx-recreate -n dev"
