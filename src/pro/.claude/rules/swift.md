# Swift Rules

## Safety
- Avoid force unwrapping (`!`) — use `guard let`, `if let`, or `??`
- Use `@MainActor` for UI-related code
- Mark classes as `final` unless designed for inheritance
- Use `Sendable` protocol for types crossing concurrency boundaries

## Patterns
- Prefer structs over classes (value semantics)
- Use protocols with extensions for shared behavior
- Use `Result<T, Error>` for failable operations
- Use property wrappers for cross-cutting concerns
- Prefer composition over inheritance

## Naming
- Follow Swift API Design Guidelines
- Use camelCase for variables, functions, parameters
- Use PascalCase for types, protocols, enums
- Prefix boolean properties with `is`, `has`, `should`

## Concurrency
- Use structured concurrency (async/await, TaskGroup)
- Avoid unstructured `Task { }` when possible
- Use actors for mutable shared state
- Cancel tasks when their owner is deallocated

## Memory
- Use `[weak self]` in closures that outlive their scope
- Avoid retain cycles — break with `weak` or `unowned`
- Use `Instruments` to profile memory usage
- Prefer value types to avoid reference counting overhead

## SwiftUI
- Keep views small and focused
- Extract subviews for reuse
- Use `@StateObject` for creation, `@ObservedObject` for injection
- Prefer `@Environment` over deep prop drilling
- Use `ViewModifier` for reusable styling

## Error Handling
- Use typed throws where possible (Swift 6+)
- Define domain-specific error enums
- Provide user-facing error messages separately from technical errors
- Log errors with structured context
