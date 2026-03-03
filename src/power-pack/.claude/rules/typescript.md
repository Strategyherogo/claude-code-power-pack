# TypeScript Rules

## Type Safety
- Enable `strict: true` in tsconfig.json
- Never use `any` — use `unknown` and narrow with type guards
- Prefer interfaces for object shapes, type aliases for unions/intersections
- Use discriminated unions over optional fields for variant types
- Export types alongside their implementations

## Patterns
- Use `readonly` for arrays and objects that shouldn't be mutated
- Prefer `const` assertions for literal types
- Use `satisfies` operator for type-safe object literals
- Avoid type assertions (`as`) — use type guards instead
- Use `Record<K, V>` over index signatures

## Functions
- Use explicit return types for public functions
- Prefer arrow functions for callbacks
- Use function declarations for top-level functions
- Avoid default exports — use named exports

## Error Handling
- Use custom error classes extending Error
- Catch specific error types, not generic catch-all
- Never swallow errors silently
- Use Result/Either pattern for expected failures

## Async
- Always handle Promise rejections
- Prefer async/await over .then() chains
- Use Promise.all() for parallel operations
- Cancel unnecessary pending operations on cleanup

## Imports
- Use absolute imports with path aliases
- Group: external libs → internal modules → relative imports
- No circular dependencies
