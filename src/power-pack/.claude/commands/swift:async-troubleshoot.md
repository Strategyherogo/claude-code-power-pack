# Skill: swift:async-troubleshoot
Diagnose and fix Swift async/await, MainActor, and structured concurrency issues.

## Auto-Trigger
**When:** "async await", "MainActor", "Task", "actor isolation", "swift concurrency", "structured concurrency"

## Common Issues & Fixes

### 1. MainActor UI Updates
```swift
// ❌ CRASH - updating UI from background
Task {
    let data = await fetchData()
    self.label.text = data  // Crash: not on main thread
}

// ✅ FIX - MainActor annotation
@MainActor
func updateUI(with data: String) {
    self.label.text = data
}

Task {
    let data = await fetchData()
    await updateUI(with: data)
}

// ✅ OR - inline MainActor.run
Task {
    let data = await fetchData()
    await MainActor.run {
        self.label.text = data
    }
}
```

### 2. Actor Isolation Errors
```swift
// ❌ ERROR - accessing actor property directly
actor Counter {
    var count = 0
}

let counter = Counter()
print(counter.count)  // Error: actor-isolated

// ✅ FIX - await access
print(await counter.count)

// ✅ OR - nonisolated for safe properties
actor Counter {
    nonisolated let id = UUID()  // Safe to access directly
    var count = 0
}
```

### 3. Task Cancellation
```swift
// ❌ PROBLEM - ignoring cancellation
Task {
    for item in items {
        await process(item)  // Continues even if cancelled
    }
}

// ✅ FIX - check cancellation
Task {
    for item in items {
        try Task.checkCancellation()  // Throws if cancelled
        await process(item)
    }
}

// ✅ OR - cooperative cancellation
Task {
    for item in items {
        guard !Task.isCancelled else { return }
        await process(item)
    }
}
```

### 4. Deadlocks with sync → async
```swift
// ❌ DEADLOCK - blocking main thread waiting for async
func syncMethod() {
    let semaphore = DispatchSemaphore(value: 0)
    Task {
        await asyncWork()
        semaphore.signal()
    }
    semaphore.wait()  // Deadlock if on main thread
}

// ✅ FIX - make caller async
func asyncMethod() async {
    await asyncWork()
}

// ✅ OR - use completion handler bridge
func syncMethod(completion: @escaping () -> Void) {
    Task {
        await asyncWork()
        completion()
    }
}
```

### 5. Sendable Conformance
```swift
// ❌ WARNING - non-Sendable type crossing actor boundary
class MyData {  // Not Sendable
    var value: String
}

actor MyActor {
    func process(_ data: MyData) { }  // Warning
}

// ✅ FIX - make Sendable
final class MyData: Sendable {
    let value: String  // Must be immutable
}

// ✅ OR - use @unchecked Sendable carefully
final class MyData: @unchecked Sendable {
    private var value: String  // You ensure thread safety
}
```

### 6. async let vs Task
```swift
// Use async let for structured, parallel work
async let result1 = fetch1()
async let result2 = fetch2()
let combined = await (result1, result2)  // Parallel

// Use Task for fire-and-forget or unstructured
Task {
    await backgroundWork()  // Independent lifetime
}

// Use TaskGroup for dynamic parallelism
await withTaskGroup(of: Int.self) { group in
    for url in urls {
        group.addTask { await fetch(url) }
    }
    for await result in group {
        process(result)
    }
}
```

## Debugging Workflow

### Phase 1: Identify (5 min)
```
□ Read exact error/warning message
□ Identify which actor/isolation context
□ Check if MainActor required
□ Look for Sendable warnings
□ Check for data races
```

### Phase 2: Analyze (5 min)
```
□ Trace async call chain
□ Identify isolation boundaries
□ Check for blocking calls (semaphore, wait)
□ Review Task creation points
□ Map actor boundaries
```

### Phase 3: Fix (10 min)
```
□ Add @MainActor where UI involved
□ Make types Sendable if crossing boundaries
□ Replace blocking with async alternatives
□ Add cancellation checks for long tasks
□ Use proper Task type (Task vs TaskGroup)
```

### Phase 4: Verify (5 min)
```
□ Build succeeds with strict concurrency
□ No runtime crashes
□ UI updates smooth
□ Tasks cancel properly
□ No data race warnings
```

## Xcode Settings for Strict Checking
```
Build Settings:
- Swift Concurrency Checking: Complete
- Strict Concurrency Checking: Yes
```

## Quick Reference

| Pattern | When to Use |
|---------|-------------|
| `@MainActor` | Any UI code |
| `async let` | Parallel work, structured |
| `Task { }` | Fire-and-forget |
| `Task.detached` | Truly independent work |
| `TaskGroup` | Dynamic parallel tasks |
| `nonisolated` | Safe properties on actors |
| `@Sendable` | Closures crossing boundaries |

## Related Skills
- `/swift:debug-memory` - Memory leaks with async
- `/swift:app-store-prep` - Testing before submission

---
Last updated: 2026-01-27
