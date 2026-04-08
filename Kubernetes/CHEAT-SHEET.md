# 🔥 Kubernetes Interview Cheat Sheet

**Print this page. Memorize it. Master it. 🎯**

---

## ⚡ Essential Commands

### Namespaces
```bash
kubectl create namespace dev
kubectl get ns
kubectl delete ns dev
```

### Pods
```bash
kubectl run pod1 --image=nginx -n dev              # Create
kubectl get pods -A                                # List all
kubectl get pods --show-labels -A                 # With labels
kubectl get pods -l env=dev -A                    # Filter by label
kubectl describe pod pod1 -n dev                  # Details
kubectl logs pod1 -n dev                          # Logs
kubectl logs pod1 -n dev -c container-name        # Logs by container
```

### Deployments
```bash
kubectl create deployment nginx --image=nginx --replicas=3
kubectl get deploy
kubectl set image deployment/nginx nginx=nginx:1.25
kubectl rollout status deployment/nginx
kubectl rollout history deployment/nginx
kubectl rollout undo deployment/nginx
kubectl rollout undo deployment/nginx --to-revision=1
```

### Watch Real-Time
```bash
kubectl get pods -w
kubectl get pods -w -l app=nginx
```

---

## 🎯 Zero Downtime Strategy (MEMORIZE!)

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1           # Create 1 extra pod first
    maxUnavailable: 0     # NEVER reduce below replica count
```

**What happens:** Pod added → tested → old pod removed → repeat

---

## 📊 Strategy Comparison

| Strategy | maxSurge | maxUnavailable | Result |
|----------|---|---|---|
| **Zero Downtime** ⭐ | 1 | 0 | Always 3 serving |
| Faster | 0 | 1 | Temporary dip to 2 |
| Aggressive | 2 | 2 | Can go to 1 pod |
| Percentage | 50% | 25% | Dynamic based on replicas |
| Recreate | - | - | ❌ Full downtime |

---

## 🔄 Container Patterns

| Type | When | How Long | Use For |
|------|------|----------|---------|
| **Init** | Before app | Exits after success | DB checks, setup |
| **Sidecar** | With app | App lifetime | Logs, monitoring |
| **Ambassador** | With app | App lifetime | External proxy |

---

## 🚨 Debug Checklist

```bash
# 1. Check status
kubectl rollout status deployment/myapp

# 2. View pods
kubectl get pods

# 3. Pod details (check error message!)
kubectl describe pod <pod-name>

# 4. App logs
kubectl logs <pod-name>

# 5. System events
kubectl get events --sort-by=.metadata.creationTimestamp

# 6. Deployment details
kubectl describe deployment myapp
```

**Common Errors:**
- `ImagePullBackOff` → Wrong image name
- `CrashLoopBackOff` → App crashed
- `Pending` → Resources unavailable

---

## 🆘 Emergency Rollback

```bash
# Instant revert
kubectl rollout undo deployment/myapp

# Verify
kubectl rollout status deployment/myapp
```

---

## 📝 Interview Questions (Practice These!)

### Q1: Zero Downtime?
**Answer:** `maxUnavailable: 0` + `maxSurge: 1`  
New pod → ready → old pod deleted → repeat

### Q2: Stuck Rollout?
**Answer:** Check pod status, logs, events, resources

### Q3: Init vs Sidecar?
**Answer:**
- Init: Before app, once, must succeed
- Sidecar: With app, continuous, helper

### Q4: Fastest Deployment?
**Answer:** `maxSurge: 2` + `maxUnavailable: 2` (but risky!)

### Q5: Critical Service Strategy?
**Answer:** Always `maxUnavailable: 0`

### Q6: maxSurge=1 with 4 replicas means?
**Answer:** Can create UP TO 5 pods, min 4-0=4 available

### Q7: Label Filter: All prod + web tier?
**Answer:** `kubectl get pods -l env=prod,tier=web -A`

### Q8: Rollback to revision 2?
**Answer:** `kubectl rollout undo deployment/name --to-revision=2`

### Q9: Watch Pods Real-Time?
**Answer:** `kubectl get pods -w`

### Q10: See Deployment History?
**Answer:** `kubectl rollout history deployment/name`

---

## 🎯 Key Formulas

**Available Pods During Update:**
```
Min Available = Replicas - maxUnavailable
Max Pods = Replicas + maxSurge
```

**Example (3 replicas):**
- maxSurge=1, maxUnavailable=0
  - Max: 3+1 = 4 pods
  - Min: 3-0 = 3 available

---

## ✅ Pre-Interview Checklist

- [ ] Can create namespaces
- [ ] Can filter pods with -l flag
- [ ] Know zero-downtime strategy
- [ ] Can rollback instantly
- [ ] Know 3 container patterns
- [ ] Can debug stuck deployment
- [ ] Know maxSurge formula
- [ ] Know when to use each strategy

---

## 💻 30-Second Drill

```bash
# 1. Create namespace
kubectl create namespace dev

# 2. Deploy
kubectl create deployment nginx --image=nginx -n dev

# 3. Update
kubectl set image deployment/nginx nginx=nginx:1.25 -n dev

# 4. Watch
kubectl get pods -w -n dev

# 5. Check status
kubectl rollout status deployment/nginx -n dev

# 6. View history
kubectl rollout history deployment/nginx -n dev

# 7. Rollback
kubectl rollout undo deployment/nginx -n dev
```

---

## 🔥 Last Minute Tips

1. **Always test maxSurge with `kubectl get pods -w`**
   - You MUST see pods going up to (replicas + maxSurge)
   - You MUST see pods never going below (replicas - maxUnavailable)

2. **Zero downtime = maxUnavailable: 0 (ALWAYS)**
   - This is the only correct answer for critical services

3. **Emergency scenarios:**
   - Stuck rollout? → `kubectl rollout undo`
   - Wrong image? → `kubectl rollout undo`
   - Need to debug? → `kubectl describe pod`

4. **Interview killer phrase:**
   - "Set maxUnavailable to 0 to ensure zero downtime, and use maxSurge to create gradual replacements"

---

## 📚 5-Minute Breakdown

| Time | Topic |
|------|-------|
| 0-1 min | Explain zero-downtime strategy |
| 1-2 min | Show maxSurge + maxUnavailable formula |
| 2-3 min | Demonstrate debug process |
| 3-4 min | Explain rollback procedure |
| 4-5 min | Answer any follow-up |

---

## 🎓 What Interviewers Want to Hear

✅ "maxUnavailable: 0 for zero downtime"  
✅ "maxSurge: 1 to gradually replace pods"  
✅ "I'd check pod status, logs, and events to debug"  
✅ "Rollback with kubectl rollout undo"  
✅ "Init containers run before the app"  
✅ "Sidecars run alongside the app"  

❌ Don't say: "I'm not sure"  
❌ Don't say: "Recreate strategy is fine" (it causes downtime!)  
❌ Don't say: "I've never rolled back" (practice first!)  

---

## 🚀 Practice Until...

- [ ] You can explain zero-downtime WITHOUT reading notes
- [ ] You can draw maxSurge/maxUnavailable timeline from memory
- [ ] You can write strategy YAML in 2 minutes
- [ ] You can debug deployment in 30 seconds
- [ ] You can answer all 10 questions smoothly

---

**Print This. Memorize This. Pass That Interview.** 🎯

*Last Updated: 2026-04-08*
