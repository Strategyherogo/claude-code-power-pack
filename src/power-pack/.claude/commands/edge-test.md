# Skill: Edge Test
Test boundary conditions and edge cases.

## Auto-Trigger
**When:** "edge case", "boundary", "corner case", "extreme"

## Edge Case Categories

### Input Boundaries
```
□ Empty input (null, undefined, "", [], {})
□ Single item
□ Maximum size/length
□ Negative numbers
□ Zero
□ Very large numbers (MAX_SAFE_INTEGER)
□ Special characters
□ Unicode/emoji
□ Whitespace only
```

### Data Types
```
□ Wrong type passed
□ Type coercion edge cases
□ NaN, Infinity
□ Date edge cases (leap year, DST)
□ Timezone boundaries
□ Floating point precision
```

### Timing
```
□ Concurrent operations
□ Race conditions
□ Timeout scenarios
□ Rapid repeated calls
□ Slow network
□ Clock skew
```

### State
```
□ Uninitialized state
□ Partial state
□ Corrupted state
□ State during transitions
□ Recovery after crash
```

## Test Template
```typescript
describe('EdgeCases', () => {
  describe('Empty Inputs', () => {
    it('handles null', () => {});
    it('handles undefined', () => {});
    it('handles empty string', () => {});
    it('handles empty array', () => {});
  });

  describe('Boundaries', () => {
    it('handles minimum value', () => {});
    it('handles maximum value', () => {});
    it('handles zero', () => {});
    it('handles negative', () => {});
  });

  describe('Special Cases', () => {
    it('handles unicode', () => {});
    it('handles very long input', () => {});
    it('handles special characters', () => {});
  });
});
```

## Checklist Generator
For function `f(x)` that accepts `type`:
```
If type = string:
  □ ""
  □ " " (whitespace)
  □ "a" (single char)
  □ Very long string (10000+ chars)
  □ Unicode: "日本語"
  □ Emoji: "🎉"
  □ Special: "<script>alert(1)</script>"

If type = number:
  □ 0
  □ -1
  □ 1
  □ Number.MAX_SAFE_INTEGER
  □ Number.MIN_SAFE_INTEGER
  □ NaN
  □ Infinity
  □ -Infinity
  □ 0.1 + 0.2 (floating point)

If type = array:
  □ []
  □ [single]
  □ [many, many, ...]
  □ Sparse array
  □ Nested arrays
```

---
Last updated: 2026-01-27
