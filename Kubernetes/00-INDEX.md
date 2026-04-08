# 📚 Kubernetes Lab - Complete File Index

**Created:** April 8, 2026  
**Status:** ✅ Ready for Practice

---

## 📂 Full Directory Structure

```
d:\Study\Kubernetes\
│
├── README.md                          📖 START HERE - Complete guide & cheat sheet
├── k8s-complete-lab.md                📖 Detailed lab instructions
├── mypod.yaml                         📋 Manual single pod
├── multicontainerpod.yml              📋 Multi-container pod example
│
├── 00-Namespaces/
│   ├── create-namespaces.yaml         ☸️  YAML: Create 3 namespaces
│   └── commands.sh                    🔧 Commands: Create namespaces
│
├── 01-Basic-Pods/
│   ├── pod-single-container.yaml      ☸️  Single container pod
│   ├── pod-with-labels.yaml           ☸️  5 pods with labels (dev/staging/prod)
│   └── commands.sh                    🔧 Commands: Create, filter with -l
│
├── 02-Container-Patterns/
│   ├── 01-init-container.yaml         ☸️  Init container (runs before app)
│   ├── 02-sidecar-container.yaml      ☸️  Sidecar (logger)
│   ├── 03-ambassador-container.yaml   ☸️  Ambassador (external proxy)
│   ├── 04-all-patterns-combined.yaml  ☸️  ALL 3 PATTERNS IN ONE POD
│   └── commands.sh                    🔧 Commands: Deploy & test all
│
├── 03-Deployments-Basic/
│   ├── deployment-basic.yaml          ☸️  Basic 3-replica deployment
│   └── commands.sh                    🔧 Commands: Create & update
│
├── 04-Rolling-Update-Strategies/      ⭐ MOST IMPORTANT FOR INTERVIEWS
│   ├── 01-strategy-zero-downtime.yaml ☸️  maxSurge=1, maxUnavailable=0 (BEST!)
│   ├── 02-strategy-faster.yaml        ☸️  maxSurge=0, maxUnavailable=1
│   ├── 03-strategy-aggressive.yaml    ☸️  maxSurge=2, maxUnavailable=2
│   ├── 04-strategy-percentage.yaml    ☸️  Percentage-based (scalable)
│   ├── 05-strategy-recreate.yaml      ☸️  Recreate (downtime - avoid!)
│   └── commands.sh                    🔧 Commands: Test all 5 strategies
│
└── 05-Interview-Questions/
    ├── interview-qa.md                🎯 10 interview scenarios with answers
    └── commands.sh                    🔧 Commands to practice questions

```

---

## 🎯 What Each File Does

### 📂 00-Namespaces
| File | Purpose |
|------|---------|
| `create-namespaces.yaml` | YAML to create dev, staging, prod namespaces |
| `commands.sh` | Commands to create namespaces imperatively |

### 📂 01-Basic-Pods
| File | Purpose |
|------|---------|
| `pod-single-container.yaml` | Simple nginx pod example |
| `pod-with-labels.yaml` | 5 pods with complex labels for filtering |
| `commands.sh` | Create pods, add labels, filter with -l flag |

### 📂 02-Container-Patterns
| File | Purpose |
|------|---------|
| `01-init-container.yaml` | Pod with init container (pre-setup) |
| `02-sidecar-container.yaml` | Pod with sidecar (logger) |
| `03-ambassador-container.yaml` | Pod with ambassador (external proxy) |
| `04-all-patterns-combined.yaml` | **PRODUCTION EXAMPLE**: All 3 patterns together |
| `commands.sh` | Deploy all patterns and view logs |

### 📂 03-Deployments-Basic
| File | Purpose |
|------|---------|
| `deployment-basic.yaml` | Simple 3-replica deployment |
| `commands.sh` | Create, update, rollback, history |

### 📂 04-Rolling-Update-Strategies ⭐
| File | Strategy | maxSurge | maxUnavailable | Use Case |
|------|----------|----------|---|---|
| `01-strategy-zero-downtime.yaml` | Best Practice | 1 | 0 | **Production** |
| `02-strategy-faster.yaml` | Risky | 0 | 1 | Non-critical |
| `03-strategy-aggressive.yaml` | Fast | 2 | 2 | Testing |
| `04-strategy-percentage.yaml` | Dynamic | 50% | 25% | Scalable |
| `05-strategy-recreate.yaml` | ❌ Avoid | - | - | Downtime |

### 📂 05-Interview-Questions
| File | Purpose |
|------|---------|
| `interview-qa.md` | 10 Q&A scenarios with detailed answers |
| `commands.sh` | Practice commands for each scenario |

---

## 🚀 How to Use This Lab

### Day 1: Foundations (1-2 hours)
```bash
# Start with namespaces
cd 00-Namespaces && bash commands.sh

# Then basic pods  
cd ../01-Basic-Pods && bash commands.sh
```
📚 Learn: namespace isolation, imperative vs declarative, label filtering

### Day 2: Container Patterns (1-2 hours)
```bash
cd ../02-Container-Patterns && bash commands.sh
```
📚 Learn: init containers, sidecars, ambassadors

### Day 3: Deployments (1-2 hours)
```bash
cd ../03-Deployments-Basic && bash commands.sh
```
📚 Learn: replica management, rolling updates, rollbacks

### Day 4: Advanced Strategies (2-3 hours) ⭐ CRITICAL
```bash
cd ../04-Rolling-Update-Strategies && bash commands.sh

# Watch pods in real-time
kubectl get pods -w
```
📚 Learn: maxSurge, maxUnavailable, zero-downtime deployment

### Day 5: Interview Prep (1-2 hours)
```bash
cd ../05-Interview-Questions
cat interview-qa.md
bash commands.sh
```
📚 Learn: Real-world scenarios, troubleshooting, debugging

---

## 📝 File Statistics

| Category | Files | Total |
|----------|-------|-------|
| YAML Files | 13 | ~450 lines |
| Script Files | 6 | ~200 lines |
| Documentation | 3 | ~600 lines |
| **Total** | **22** | **~1,250 lines** |

---

## ✅ Verification Checklist

Run this after completing each section:

### Phase 1: Namespaces
- [ ] `kubectl get ns` shows dev, staging, prod
- [ ] All 3 namespaces are active

### Phase 2: Basic Pods
- [ ] `kubectl get pods -A` shows 5 pods
- [ ] `kubectl get pods -l env=prod -A` shows 2 pods
- [ ] Label filtering works correctly

### Phase 3: Container Patterns
- [ ] Init container pod runs successfully
- [ ] Sidecar logger logs appear
- [ ] Ambassador pod runs
- [ ] Combined pod has all 3 patterns

### Phase 4: Deployment Strategies
- [ ] Zero-downtime strategy deploys smoothly
- [ ] You understand maxSurge behavior
- [ ] You understand maxUnavailable behavior
- [ ] Rollback works instantly

### Phase 5: Interview Ready
- [ ] You can answer 5+ questions
- [ ] You can debug deployments
- [ ] You know when to use each strategy
- [ ] You can perform emergency rollback

---

## 🔥 Key Interview Points

**Memorize These:**

1. **Zero Downtime Formula**
   ```yaml
   maxSurge: 1
   maxUnavailable: 0
   ```

2. **Debug Steps**
   ```bash
   kubectl rollout status deployment/name
   kubectl describe pod <name>
   kubectl logs <name>
   kubectl get events
   ```

3. **Emergency Rollback**
   ```bash
   kubectl rollout undo deployment/name
   ```

4. **Pattern Differences**
   - Init: Before app (once)
   - Sidecar: With app (continuous)
   - Ambassador: With app (proxy)

---

## 📚 Reference Files

| File | When to Use |
|------|------------|
| `README.md` | **Start here** - overview & commands |
| `k8s-complete-lab.md` | Detailed step-by-step guide |
| `interview-qa.md` | Before interviews - practice Q&A |
| YAML files | Apply with `kubectl apply -f` |
| commands.sh | Execute with `bash commands.sh` |

---

## 🎓 Profile After Completion

**You will be able to:**

✅ Create namespaces imperatively & declaratively  
✅ Create pods with labels and filter them  
✅ Explain init containers, sidecars, ambassadors  
✅ Perform rolling updates without downtime  
✅ Rollback deployments instantly  
✅ Debug stuck deployments  
✅ Understand maxSurge & maxUnavailable deeply  
✅ Answer 10+ DevOps interview questions  
✅ Handle real-world Kubernetes scenarios  

---

## 💡 Pro Tips

- 📋 Print `README.md` as your cheat sheet
- ⏱️ Spend most time on Phase 4 (strategies)
- 👀 Always use `kubectl get pods -w` to watch changes
- 🔄 Repeat all 5 strategies 3-4 times until fluid
- 🎯 Record yourself explaining each concept

---

## 🚀 Next Steps

After mastering this lab:

1. **Blue/Green Deployments** - Instant switch strategies
2. **Canary Deployments** (Argo Rollouts) - Gradual traffic shift
3. **HPA Autoscaling** - Scale based on metrics
4. **Service Mesh** (Istio) - Advanced traffic management
5. **Real Project** - Deploy something in production

---

**Status:** ✅ **COMPLETE & READY FOR INTERVIEW PREP**

**Time to Master:** 3-5 days with 2-3 hours daily practice

**Recommended:** Do Phase 4 (strategies) at least 3 times!

---

*Created: April 8, 2026*  
*Kubernetes Version: 1.28+*  
*Prepared for: DevOps Interview Success* 🎯
