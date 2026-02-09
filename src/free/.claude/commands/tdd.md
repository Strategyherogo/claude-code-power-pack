# Skill: TDD (Test-Driven Development)
Write tests first, then implementation.

## Auto-Trigger
**When:** "test first", "tdd", "write test", "test driven"

## Workflow

### Step 1: Red - Write Failing Test
```
□ Define expected behavior
□ Write test that fails
□ Run test to confirm failure
□ Keep test simple and focused
```

### Step 2: Green - Minimal Implementation
```
□ Write simplest code to pass
□ Don't optimize yet
□ Run test to confirm pass
□ Commit passing state
```

### Step 3: Refactor - Clean Up
```
□ Improve code structure
□ Remove duplication
□ Ensure tests still pass
□ Commit refactored state
```

## Test Templates

### JavaScript/TypeScript (Jest)
```typescript
describe('FeatureName', () => {
  it('should do expected behavior', () => {
    // Arrange
    const input = 'test';

    // Act
    const result = featureFunction(input);

    // Assert
    expect(result).toBe('expected');
  });
});
```

### Python (pytest)
```python
def test_feature_expected_behavior():
    # Arrange
    input_data = "test"

    # Act
    result = feature_function(input_data)

    # Assert
    assert result == "expected"
```

### Swift (XCTest)
```swift
func testFeatureExpectedBehavior() {
    // Arrange
    let input = "test"

    // Act
    let result = featureFunction(input)

    // Assert
    XCTAssertEqual(result, "expected")
}
```

## Test Categories
```
□ Unit tests (isolated, fast)
□ Integration tests (component interaction)
□ E2E tests (full flow)
□ Edge case tests
□ Error case tests
```

---
Last updated: 2026-01-27
