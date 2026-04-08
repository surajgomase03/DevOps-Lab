# 🔥 Kubernetes Interview Questions & Scenarios

## Question 1: Zero Downtime Deployment
**Scenario:** Your service is critical. You need to deploy a new version with absolutely zero downtime.

**What strategy would you use?**
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```
**Why?**
- `maxUnavailable: 0` → Never reduce pods below replica count
- `maxSurge: 1` → Create extra pod first, then delete old one
- Result: Always 3 pods available during update

**Commands:**
```bash
kubectl set image deployment/myapp myapp=myapp:v2 --record
kubectl rollout status deployment/myapp
kubectl get pods -w  # Watch
```

---

## Question 2: Deployment Stuck - Troubleshooting
**Scenario:** You deployed a new image, but rollout status shows "waiting"

**What commands would you use to debug?**
```bash
# 1. Check rollout status
kubectl rollout status deployment/myapp

# 2. See current pod state
kubectl get pods
kubectl describe pod <pod-name>

# 3. Check events
kubectl get events --sort-by=.metadata.creationTimestamp

# 4. View deployment details
kubectl describe deployment myapp

# 5. Check logs
kubectl logs <pod-name>
```

**Common Issues:**
- `ImagePullBackOff` → Wrong image name
- `CrashLoopBackOff` → App crashed
- `Pending` → Not enough resources

---

## Question 3: Rollback Scenario
**Scenario:** You deployed v2, but it has bugs. Revert ASAP.

**What's the fastest way?**
```bash
# Instant rollback
kubectl rollout undo deployment/myapp

# Verify
kubectl rollout status deployment/myapp
```

**To rollback to specific version:**
```bash
# View history
kubectl rollout history deployment/myapp

# Rollback to revision 1
kubectl rollout undo deployment/myapp --to-revision=1
```

---

## Question 4: maxSurge vs maxUnavailable
**Scenario:** You have 4 replicas. Explain what happens with:
- maxSurge=2
- maxUnavailable=1

**Answer:**
```
Min available pods = 4 - 1 = 3
Max pods = 4 + 2 = 6

Timeline:
1. Start: 4 pods (old)
2. Create 2 new → total 6
3. Kill 1 old → total 5 (min 3 available ✓)
4. Kill 1 old → total 4
5. Complete: 4 pods (new)
```

---

## Question 5: Init Container Use Case
**Scenario:** Your app requires a database connection before starting. How do you ensure DB is ready?

**Answer:**
```yaml
initContainers:
- name: wait-for-db
  image: busybox
  command:
    - sh
    - -c
    - |
      until nc -z db.default.svc.cluster.local 5432; do
        echo "Waiting for database..."
        sleep 2
      done
```

**Why init container?**
- Runs before main app
- Must complete successfully
- Pod won't start if init fails
- Perfect for setup tasks

---

## Question 6: Sidecar vs Ambassador vs Init
**Scenario:** Classify these requirements:

| Need | Answer | Why |
|------|--------|-----|
| Pre-setup database | Init Container | Runs once before app |
| Log collection | Sidecar | Runs with app, collects logs |
| External service proxy | Ambassador | Routes traffic outside |

---

## Question 7: Label Filtering Complex Query
**Scenario:** Get all production web tier pods that are NOT API services.

**Commands:**
```bash
# Get prod + web tier pods
kubectl get pods -l env=prod,tier=web -A

# Get prod + exclude API
kubectl get pods -l env=prod,app!=api -A

# Complex: prod AND (web OR api)
kubectl get pods -l env=prod -A | grep -E 'web|api'

# Get pods by namespace + label
kubectl get pods -n prod -l tier=frontend
```

---

## Question 8: Deployment Revision History
**Scenario:** You made 5 deployments. View history.

**Commands:**
```bash
# See all revisions
kubectl rollout history deployment/myapp

# See details of revision 2
kubectl rollout history deployment/myapp --revision=2

# Rollback to revision 2
kubectl rollout undo deployment/myapp --to-revision=2
```

---

## Question 9: Watch Real-Time Pod Changes
**Scenario:** You started a deployment. Watch pods being created/destroyed.

**Command:**
```bash
# Watch pods in real-time
kubectl get pods -w

# Watch with labels
kubectl get pods -w -l app=nginx

# Watch specific namespace
kubectl get pods -w -n dev
```

---

## Question 10: Emergency Deployment Cancel
**Scenario:** You accidentally deployed wrong image. Stop rollout ASAP.

**Commands:**
```bash
# Check current rollout
kubectl rollout status deployment/myapp

# Undo immediately
kubectl rollout undo deployment/myapp

# Verify rollback
kubectl get pods
kubectl rollout status deployment/myapp
```

---

## Bonus: Pod Resource Issue
**Scenario:** Pod stuck in Pending state during deployment.

**Debug:**
```bash
kubectl describe pod <pod-name>
# Look for: Insufficient CPU, Insufficient memory

# Check node resources
kubectl describe nodes
kubectl top nodes

# Check pod resource requests
kubectl describe deployment myapp | grep -A5 requests
```

---

## Interview Checklist ✅
- [ ] Explain maxSurge & maxUnavailable
- [ ] Rollback without service disruption
- [ ] Debug stuck deployments
- [ ] Difference between Init/Sidecar/Ambassador
- [ ] Label filtering with -l flag
- [ ] Read logs from specific container
- [ ] Check deployment revision history
- [ ] Monitor rollout in real-time
- [ ] Handle resource constraints
- [ ] Explain rolling update strategy choice
