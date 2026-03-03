# Skill: perf-test
Performance testing and benchmarking.

## Auto-Trigger
**When:** "perf test", "performance", "benchmark", "load test", "stress test", "speed test"

## Quick Performance Checks

### API Response Time
```bash
# Simple timing
time curl -s https://api.example.com/endpoint > /dev/null

# Detailed timing
curl -w "@curl-format.txt" -o /dev/null -s https://api.example.com/endpoint

# curl-format.txt:
#   time_namelookup:  %{time_namelookup}s\n
#   time_connect:     %{time_connect}s\n
#   time_appconnect:  %{time_appconnect}s\n
#   time_pretransfer: %{time_pretransfer}s\n
#   time_redirect:    %{time_redirect}s\n
#   time_starttransfer: %{time_starttransfer}s\n
#   time_total:       %{time_total}s\n
```

### Load Testing with wrk
```bash
# Install
brew install wrk

# Basic load test (30s, 12 threads, 400 connections)
wrk -t12 -c400 -d30s https://api.example.com/endpoint

# With custom headers
wrk -t12 -c400 -d30s -H "Authorization: Bearer token" https://api.example.com/endpoint
```

### Load Testing with k6
```javascript
// k6-script.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 100,           // Virtual users
  duration: '30s',    // Test duration
};

export default function() {
  const res = http.get('https://api.example.com/endpoint');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });
  sleep(1);
}
```

```bash
# Run k6
brew install k6
k6 run k6-script.js
```

## Benchmark Template

```markdown
## Performance Benchmark Report
**Date:** [YYYY-MM-DD]
**Environment:** [staging/production]
**Tool:** [wrk/k6/artillery]

### Test Configuration
- **Duration:** 60 seconds
- **Concurrent users:** 100
- **Endpoint:** GET /api/users

### Results

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Avg Response Time | 45ms | <100ms | ✅ |
| P95 Response Time | 120ms | <200ms | ✅ |
| P99 Response Time | 250ms | <500ms | ✅ |
| Requests/sec | 2,500 | >1,000 | ✅ |
| Error Rate | 0.1% | <1% | ✅ |

### Response Time Distribution
```
  0-50ms:   ████████████████ 65%
 50-100ms:  ████████ 25%
100-200ms:  ███ 8%
200-500ms:  █ 2%
500ms+:     0%
```

### Observations
- [Notable finding 1]
- [Notable finding 2]

### Recommendations
1. [Optimization suggestion]
2. [Caching opportunity]
```

## Performance Targets

### Web APIs
| Metric | Good | Acceptable | Poor |
|--------|------|------------|------|
| Response time (avg) | <100ms | <300ms | >500ms |
| Response time (P95) | <200ms | <500ms | >1s |
| Throughput | >1000 rps | >500 rps | <100 rps |
| Error rate | <0.1% | <1% | >5% |

### Web Pages
| Metric | Good | Acceptable | Poor |
|--------|------|------------|------|
| LCP | <2.5s | <4s | >4s |
| FID | <100ms | <300ms | >300ms |
| CLS | <0.1 | <0.25 | >0.25 |

## Quick Commands
```
/perf-test api [url]           # API benchmark
/perf-test load [url] [users]  # Load test
/perf-test compare [a] [b]     # Compare two versions
```

## Tools Reference
- **wrk:** HTTP benchmarking
- **k6:** Load testing with JS
- **artillery:** YAML-based load tests
- **Lighthouse:** Web page performance
- **hyperfine:** CLI benchmarking

---
Last updated: 2026-01-29
