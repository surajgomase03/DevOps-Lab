# 🚀 Kubernetes Complete Lab Practice Guide

Complete hands-on practice for DevOps interviews with proper folder structure.

---

## 📁 Folder Structure Overview

```
d:\Study\Kubernetes\
├── 00-Namespaces/                    # Namespace creation & management
│   ├── create-namespaces.yaml        # YAML: Create dev/staging/prod namespaces
│   └── commands.sh                   # Commands: Imperative & declarative methods
│
├── 01-Basic-Pods/                    # Pod creation & label filtering
│   ├── pod-single-container.yaml     # Simple single container pod
│   ├── pod-with-labels.yaml          # 5 pods with complex labels
│   └── commands.sh                   # Pod management & filtering (-l flag)
│
├── 02-Container-Patterns/            # Init, Sidecar, Ambassador patterns
│   ├── 01-init-container.yaml        # Init container (runs before app)
│   ├── 02-sidecar-container.yaml     # Sidecar (runs with app)
│   ├── 03-ambassador-container.yaml  # Ambassador (proxy to external service)
│   ├── 04-all-patterns-combined.yaml # All 3 patterns in one pod
│   └── commands.sh                   # Deploy & viewing logs
│
├── 03-Deployments-Basic/             # Basic deployment operations
│   ├── deployment-basic.yaml         # Simple 3-replica deployment
│   └── commands.sh                   # Create, update, rollback
│
├── 04-Rolling-Update-Strategies/     # 5 different rolling update strategies
│   ├── 01-strategy-zero-downtime.yaml   # maxSurge=1, maxUnavailable=0 (BEST)
│   ├── 02-strategy-faster.yaml          # maxSurge=0, maxUnavailable=1
│   ├── 03-strategy-aggressive.yaml      # maxSurge=2, maxUnavailable=2
│   ├── 04-strategy-percentage.yaml      # Percentage-based (scalable)
│   ├── 05-strategy-recreate.yaml        # Recreate (downtime, avoid!)
│   └── commands.sh                      # Test all strategies
│
├── 05-Interview-Questions/           # Real DevOps interview scenarios
│   ├── interview-qa.md               # 10 questions with detailed answers
│   └── commands.sh                   # Practice commands
│
├── k8s-complete-lab.md               # Comprehensive lab guide
├── mypod.yaml                        # Single manual pod
└── multicontainerpod.yml             # Multi-container pod example
```

---

## 🎯 Quick Start (Do These in Order)

### Phase 1: Namespaces & Basic Pods (15 min)
```bash
cd d:\Study\Kubernetes\00-Namespaces
bash commands.sh

cd ..\01-Basic-Pods
bash commands.sh
```
✅ **Learn:** Create namespaces, imperative vs declarative, label filtering

### Phase 2: Container Patterns (20 min)
```bash
cd ..\02-Container-Patterns
bash commands.sh
```
✅ **Learn:** Init containers, sidecars, ambassadors

### Phase 3: Deployments & Basic Operations (15 min)
```bash
cd ..\03-Deployments-Basic
bash commands.sh
```
✅ **Learn:** Deployment creation, updates, rollbacks

### Phase 4: Rolling Update Strategies (30 min) ⭐ MOST IMPORTANT
```bash
cd ..\04-Rolling-Update-Strategies
bash commands.sh

# Watch with -w flag for real-time observation
kubectl get pods -w
```
✅ **Learn:** maxSurge, maxUnavailable, zero-downtime deployment

### Phase 5: Interview Prep (30 min)
```bash
cd ..\05-Interview-Questions
cat interview-qa.md
bash commands.sh
```
✅ **Learn:** Real scenarios, troubleshooting, emergency situations

---

## 🔍 Key Concepts by Folder

### 00-Namespaces
- Create dev/staging/prod isolation
- Imperative: `kubectl create namespace dev`
- Declarative: `kubectl apply -f create-namespaces.yaml`

### 01-Basic-Pods
- Single container pods
- Multiple pods with labels
- Filter with `-l env=dev,app=web`
- Show labels: `kubectl get pods --show-labels`

### 02-Container-Patterns

#### Init Container ⏳
- Runs BEFORE main container
- Must complete successfully
- Pod won't start if init fails
- Use for: DB checks, file downloads, setup

#### Sidecar 🔄
- Runs alongside main container
- Shares network & storage
- Use for: logging, monitoring, proxy

#### Ambassador 🔗
- Acts as proxy to external service
- Simplifies app configuration
- Use for: external DB access, API gateway

### 03-Deployments-Basic
- Replica management
- Rolling updates automatically
- Revision history tracking

### 04-Rolling-Update-Strategies (⭐ CRITICAL FOR INTERVIEWS)

#### Strategy Comparison

| Strategy | maxSurge | maxUnavailable | Use Case |
|----------|----------|---|----------|
| **Zero Downtime** | 1 | 0 | Production critical |
| **Faster** | 0 | 1 | Non-critical app |
| **Aggressive** | 2 | 2 | Fast feedback needed |
| **Percentage** | 50% | 25% | Dynamic scaling |
| **Recreate** | - | - | AVOID! (downtime) |

#### Timeline Example (3 replicas, maxSurge=1, maxUnavailable=1)
```
Step 1: Create 1 new pod → total 4 (surge)
Step 2: Delete 1 old pod → total 3
Step 3: Create 1 new pod → total 4 (surge)
Step 4: Delete 1 old pod → total 3
Step 5: Create 1 new pod → total 4 (surge)
Step 6: Delete 1 old pod → total 3 ✅
```

---

## 📊 Commands Cheat Sheet

### Namespace Commands
```bash
kubectl create namespace dev
kubectl get ns
kubectl delete ns dev
```

### Pod Commands
```bash
# Create
kubectl run pod1 --image=nginx -n dev

# View
kubectl get pods -A
kubectl get pods --show-labels

# Filter
kubectl get pods -l env=dev -A
kubectl get pods -l env=prod,app=api -A
```

### Deployment Commands
```bash
# Create
kubectl create deployment nginx --image=nginx --replicas=3

# Update
kubectl set image deployment/nginx nginx=nginx:1.25

# Rollout Management
kubectl rollout status deployment/nginx
kubectl rollout history deployment/nginx
kubectl rollout undo deployment/nginx
kubectl rollout undo deployment/nginx --to-revision=1

# Watch
kubectl get pods -w
```

### Debugging Commands
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container> # specific container
kubectl describe deployment <name>
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## 🔥 Interview Killer Facts

### Zero Downtime Deployment
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0  # This is the key!
```

### Debug Stuck Rollout
```bash
kubectl describe deployment myapp
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get events
```

### Instant Rollback
```bash
kubectl rollout undo deployment/myapp
```

### Init vs Sidecar vs Ambassador
- **Init:** Before app starts, once
- **Sidecar:** With app, continuously
- **Ambassador:** With app, routes external

---

## ✅ Verification Checklist

After completing each phase:

### Phase 1 ✓
- [ ] Created 3 namespaces
- [ ] Created 5 pods with labels
- [ ] Filtered pods by label correctly

### Phase 2 ✓
- [ ] Deployed init container pod
- [ ] Deployed sidecar pod
- [ ] Deployed ambassador pod
- [ ] Viewed pod logs by container

### Phase 3 ✓
- [ ] Created deployment
- [ ] Updated image
- [ ] Viewed rollout history

### Phase 4 ✓
- [ ] Deployed all 5 strategy types
- [ ] Watched pods with `-w`
- [ ] Understood maxSurge behavior
- [ ] Understood maxUnavailable behavior
- [ ] Rolled back successfully

### Phase 5 ✓
- [ ] Answered 5 interview questions
- [ ] Debugged stuck deployment
- [ ] Performed emergency rollback

---

## 🎓 Interview Script (Practice This!)

**Q: How do you ensure zero downtime deployment?**
```
A: Set maxUnavailable=0 and maxSurge=1.
   This means:
   - Never reduce pods below replica count (0 downtime)
   - Create extra pod first (surge), then delete old one
   - Kubernetes waits for new pod to be ready before removing old one
   
   Commands:
   kubectl set image deployment/myapp myapp=v2
   kubectl rollout status deployment/myapp
```

**Q: Deployment is stuck, what do you check?**
```
A: 1. kubectl rollout status deployment/myapp
   2. kubectl get pods → check pod status
   3. kubectl describe pod <name> → check error
   4. kubectl logs <name> → check app logs
   5. kubectl get events → system events
   
   Common causes: ImagePullBackOff, CrashLoopBackOff, resource limits
```

**Q: Difference between init container and sidecar?**
```
A: Init container:
   - Runs BEFORE main container
   - Must complete successfully
   - Pod won't start if init fails
   - Use for: setup, dependency checks
   
   Sidecar:
   - Runs WITH main container
   - Lives as long as pod
   - Use for: logging, monitoring, proxy
```

---

## 🚀 Next Advanced Topics

- [ ] Blue/Green Deployments
- [ ] Canary Deployments (Argo Rollouts)
- [ ] HPA (Horizontal Pod Autoscaling)
- [ ] Service Mesh (Istio)
- [ ] Readiness/Liveness Probes
- [ ] Network Policies
- [ ] StatefulSets

---

## 📞 Quick Command Reference

```bash
# Always start with
kubectl get ns  # See all namespaces
kubectl get pods -A  # See all pods

# Watch in real-time
kubectl get pods -w

# Apply files
kubectl apply -f file.yaml

# Rollback ASAP
kubectl rollout undo deployment/name
```

---

**💡 Pro Tips:**
- Practice all 5 strategies until you understand the timeline
- Always use `kubectl get pods -w` to watch changes
- Interview Q&A covers 90% of real-world scenarios
- Memorize the zero-downtime strategy!

---

**Last Updated:** 2026-04-08
**Status:** ✅ Complete Lab Ready for Interview Prep
