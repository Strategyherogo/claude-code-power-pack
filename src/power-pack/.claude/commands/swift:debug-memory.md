# Skill: swift:debug-memory
Detect and fix memory leaks, retain cycles, and autoreleasepool issues in Swift/iOS.

## Auto-Trigger
**When:** "memory leak", "retain cycle", "instruments", "autoreleasepool", "swift memory"

## Debugging Workflow

### Phase 1: Identify (5 min)
```
□ Run app in Instruments (Cmd+I → Allocations)
□ Perform suspected leak action 3x
□ Capture heap snapshots between actions
□ Look for growing allocations
□ Note class names with increasing count
```

### Phase 2: Isolate (10 min)
```
□ Filter Allocations by suspected class
□ Check "Malloc Stack" for creation point
□ Review code at creation site
□ Identify strong reference holders
□ Map retain graph mentally
```

### Phase 3: Fix (15 min)

#### Retain Cycles in Closures
```swift
// ❌ LEAK - closure captures self strongly
timer = Timer.scheduledTimer {
    self.count += 1  // Strong reference
}

// ✅ FIX - weak capture
timer = Timer.scheduledTimer { [weak self] in
    self?.count += 1
}
```

#### Delegate Patterns
```swift
// ❌ LEAK - strong delegate
protocol MyDelegate: AnyObject {}
class Parent {
    var delegate: MyDelegate?  // Strong!
}

// ✅ FIX - weak delegate
class Parent {
    weak var delegate: MyDelegate?
}
```

#### Autoreleasepool with Async
```swift
// ❌ PROBLEM - blocks structured concurrency
autoreleasepool {
    await myAsyncFunction()  // May hang
}

// ✅ SOLUTION - separate sync/async
await myAsyncFunction()

// ✅ OR - wrap sync work only
Task {
    autoreleasepool {
        // Sync work only here
    }
}
```

#### NotificationCenter / KVO
```swift
// ❌ LEAK - observer not removed
NotificationCenter.default.addObserver(self, ...)

// ✅ FIX - store and remove
var observers: [NSObjectProtocol] = []

func setup() {
    let observer = NotificationCenter.default.addObserver(...)
    observers.append(observer)
}

deinit {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
}
```

### Phase 4: Verify (5 min)
```
□ Run Instruments again
□ Repeat same actions 3x
□ Confirm allocations stable
□ Check deinit is called (add print)
□ Test memory warnings (Simulator → Debug → Simulate Memory Warning)
```

## Quick Checklist
```
□ All closures use [weak self] or [unowned self]
□ Delegates are weak
□ Timers invalidated in deinit
□ Observers removed in deinit
□ No autoreleasepool around async/await
□ Parent-child relationships use weak for child→parent
```

## Instruments Tips
- **Cmd+I** to profile
- **Allocations** for heap analysis
- **Leaks** for automatic detection
- **Mark Generation** to snapshot heap state
- Filter by class name to focus

## Output
Document findings in `docs/memory-audit-YYYY-MM-DD.md`

---
Last updated: 2026-01-27
