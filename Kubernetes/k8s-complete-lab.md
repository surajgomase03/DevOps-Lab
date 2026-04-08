# 🧪 Complete Kubernetes Lab: DevOps Interview Practice

---

## 📋 Lab 1: Namespaces & Pod Filtering with Labels

### Step 1: Create Namespaces
```bash
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace prod
kubectl get ns
```

### Step 2: Create 5 Pods Imperatively
```bash
kubectl run pod1 --image=nginx -n dev
kubectl run pod2 --image=nginx -n dev
kubectl run pod3 --image=nginx -n staging
kubectl run pod4 --image=nginx -n prod
kubectl run pod5 --image=nginx -n prod
kubectl get pods -A
```

### Step 3: Add Labels
```bash
kubectl label pod pod1 env=dev app=web -n dev
kubectl label pod pod2 env=dev app=api -n dev
kubectl label pod pod3 env=staging app=web -n staging
kubectl label pod pod4 env=prod app=web -n prod
kubectl label pod pod5 env=prod app=api -n prod
kubectl get pods --show-labels -A
```

### Step 4: Filter with -l Flag
```bash
# Dev pods only
kubectl get pods -l env=dev -n dev

# Prod pods only
kubectl get pods -l env=prod -n prod

# All prod pods across namespaces
kubectl get pods -A -l env=prod

# All web apps across all namespaces
kubectl get pods -A -l app=web

# Multiple labels (AND condition)
kubectl get pods -l env=prod,app=api -n prod
```

### Step 5: Manual YAML (Apply declarative)
```bash
kubectl apply -f mypod.yaml
kubectl get pods -n dev --show-labels
```

### Cleanup
```bash
kubectl delete ns dev staging prod
```

---

## 📋 Lab 2: Container Patterns (Init, Sidecar, Ambassador)

### Current Pod with All 3 Types
Your `multicontainerpod.yml` already has:
- **initContainer**: `init-setup` (runs before app)
- **Sidecar**: `sidecar-logger` (runs with app)
- **Ambassador**: `ambassador-proxy` (routes traffic)

### Deploy and Test
```bash
kubectl apply -f d:\Study\Kubernetes\multicontainerpod.yml
kubectl get pods -n dev
kubectl describe pod app-with-sidecars -n dev
kubectl logs app-with-sidecars -c sidecar-logger -n dev
```

### Key Differences Table
| Type | Runs When | Purpose | Lifecycle |
|------|-----------|---------|-----------|
| **Init** | Before app starts | Setup, DB checks, config prep | Exits after success |
| **Sidecar** | With main app | Logging, monitoring, proxy | Lives as long as pod |
| **Ambassador** | With main app | External service proxy | Lives as long as pod |

---

## 📋 Lab 3: Deployments, Rolling Updates & Rollbacks

### Step 1: Create Deployment with 3 Replicas
```bash
kubectl create deployment nginx-deploy --image=nginx --replicas=3
kubectl get deploy
kubectl get pods
```

### Step 2: Watch Rollout Status (Real-Time)
```bash
kubectl rollout status deployment/nginx-deploy
kubectl get pods -w
```

### Step 3: Perform Rolling Update
```bash
# Update image to newer version
kubectl set image deployment/nginx-deploy nginx=nginx:1.25

# Watch real-time
kubectl rollout status deployment/nginx-deploy

# View rollout history
kubectl rollout history deployment/nginx-deploy
```

### Step 4: Simulate BAD Deployment (Wrong Image)
```bash
# Deploy with invalid image
kubectl set image deployment/nginx-deploy nginx=nginx:wrongtag

# Check pod status (will show ImagePullBackOff)
kubectl get pods
kubectl describe pod <pod-name>

# Check rollout status (will hang/fail)
kubectl rollout status deployment/nginx-deploy
```

### Step 5: Rollback to Previous Version
```bash
# Undo deployment (revert to last working version)
kubectl rollout undo deployment/nginx-deploy

# Verify rollback
kubectl rollout status deployment/nginx-deploy
kubectl get pods

# See revision history
kubectl rollout history deployment/nginx-deploy

# Rollback to specific revision
kubectl rollout undo deployment/nginx-deploy --to-revision=1
```

---

## 📋 Lab 4: maxSurge & maxUnavailable (IMPORTANT 🔥)

### Understanding the Concepts
```
replicas = 4
maxSurge = 1     → Can create UP TO 4+1 = 5 pods
maxUnavailable = 1 → Can have DOWN TO 4-1 = 3 pods available
```

### Step 1: Create Baseline Deployment
```bash
kubectl create deployment nginx-deploy --image=nginx --replicas=4
kubectl get pods
```

### Step 2: Edit Deployment Strategy
```bash
kubectl edit deployment nginx-deploy
```

**Add this strategy section:**
```yaml
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
```

### Step 3: Trigger Update & Observe Behavior
```bash
# Start update
kubectl set image deployment/nginx-deploy nginx=nginx:1.25

# Watch in real-time (MOST IMPORTANT!)
kubectl get pods -w
```

**What you'll observe:**
```
1. Pod count = 5 (original 4 + 1 surge) ← maxSurge in action
2. Old pod terminated → Pod count = 4
3. New pod created → Pod count = 5 (repeat)
4. Process continues until all 4 pods updated
```

### Step 4: Try Different Scenarios

#### ✅ Scenario A: Zero Downtime (Best Practice)
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0  # Never reduce below 4 pods!
```
**Behavior:** Safe, never loses service, but slower deployment

#### ❌ Scenario B: Faster but Risky
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 0        # Don't create extra pods
    maxUnavailable: 2  # Kill 2 pods first
```
**Behavior:** Faster, but temporary downtime (only 2 pods running)

#### ⚡ Scenario C: Aggressive (Resource Heavy)
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 2        # Can go to 6 pods
    maxUnavailable: 2  # Can go down to 2 available
```
**Behavior:** Fastest, most resource intensive

### Step 5: Visual Timeline Example

```
replicas=4, maxSurge=1, maxUnavailable=1

Time  Old  New  Total  Available  Status
────────────────────────────────────────
0     4    0    4      4          Starting
1     4    1    5      4          New pod added (surge)
2     3    1    4      3          Old pod removed
3     3    2    5      3          New pod added (surge)
4     2    2    4      3          Old pod removed
5     2    3    5      3          New pod added
6     1    3    4      3          Old pod removed
7     1    4    5      4          New pod added
8     0    4    4      4          Complete!
```

### Step 6: Apply Different Strategy
```bash
kubectl edit deployment nginx-deploy
# Change maxSurge and maxUnavailable values
# Save and exit

# Watch behavior change
kubectl set image deployment/nginx-deploy nginx=nginx:1.26
kubectl get pods -w
```

---

## 🔥 Interview Q&A

### Q1: How do you ensure zero downtime?
**Answer:**
```yaml
maxUnavailable: 0  # Always keep all replicas available
maxSurge: 1        # Create one extra during update
```

### Q2: When would you use maxUnavailable=2?
**Answer:**
- Non-critical services (development/testing)
- Services that can tolerate brief downtime
- When resource constraints prevent maxSurge scaling

### Q3: What's the difference between maxSurge=1 and maxSurge: 25%?
**Answer:**
- `maxSurge: 1` → Add exactly 1 extra pod
- `maxSurge: 25%` → Add 25% of replicas (4 replicas × 0.25 = 1 extra pod)
- Percentage is useful for dynamic replica counts

### Q4: Deployment is stuck. How do you debug?
**Answer:**
```bash
kubectl rollout status deployment/nginx-deploy
kubectl describe deployment nginx-deploy
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl logs <pod-name>
```

---

## 📊 Quick Reference Table

| Command | Purpose |
|---------|---------|
| `kubectl rollout status deployment/nginx` | Check rollout progress |
| `kubectl rollout history deployment/nginx` | View deployment versions |
| `kubectl rollout undo deployment/nginx` | Revert to previous version |
| `kubectl set image deployment/nginx nginx=nginx:1.25` | Update image |
| `kubectl edit deployment/nginx` | Edit deployment YAML |
| `kubectl get pods -w` | Watch pod changes in real-time |
| `kubectl describe pod <name>` | See detailed pod info |
| `kubectl logs <pod-name> -c <container>` | View container logs |

---

## 🎯 Complete Practice Workflow

1. ✅ Create deployment with 3 replicas
2. ✅ Set maxSurge=1, maxUnavailable=0
3. ✅ Watch pods during update with `kubectl get pods -w`
4. ✅ Update to wrong image
5. ✅ Observe ImagePullBackOff
6. ✅ Rollback with `kubectl rollout undo`
7. ✅ Verify rollback success
8. ✅ Change strategy values
9. ✅ Repeat update and watch behavior

---

## 🚀 Next Advanced Topics

- Blue/Green Deployments
- Canary Deployments (Argo Rollouts)
- HPA (Horizontal Pod Autoscaling) + Rolling Updates
- Service Mesh (Istio) + Sidecars
- Readiness/Liveness Probes with Deployments

