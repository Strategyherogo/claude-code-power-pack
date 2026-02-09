# Python Rules

## Style
- Follow PEP 8 and PEP 257
- Use type hints for all function signatures (PEP 484)
- Use f-strings over .format() or % formatting
- Use pathlib.Path over os.path
- Use dataclasses or Pydantic for structured data

## Patterns
- Use context managers (`with`) for resource management
- Prefer list/dict comprehensions over map/filter
- Use `Enum` for fixed sets of values
- Use `@property` for computed attributes
- Use `__slots__` in performance-critical classes

## Functions
- Type all parameters and return values
- Use `Optional[X]` explicitly (not `X | None` in older code)
- Max 5 parameters — use dataclass for more
- Use `*args` and `**kwargs` sparingly
- Prefer keyword arguments for clarity

## Error Handling
- Create custom exceptions inheriting from project base exception
- Use specific except clauses (never bare `except:`)
- Use `raise from` for exception chaining
- Log exceptions with traceback context

## Testing
- Use pytest (not unittest)
- Use fixtures for test setup
- Use parametrize for testing multiple cases
- Mock external services, not internal code
- Name tests: `test_<function>_<scenario>_<expected>`

## Async
- Use `asyncio` for I/O-bound concurrency
- Use `aiohttp` or `httpx` for async HTTP
- Avoid mixing sync and async code
- Use `asyncio.gather()` for parallel tasks

## Dependencies
- Pin versions in requirements.txt
- Use virtual environments (venv or poetry)
- Separate dev and production dependencies
