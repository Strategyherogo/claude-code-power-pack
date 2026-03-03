# Skill: compliance-pack
Generate compliance documentation package.

## Auto-Trigger
**When:** "compliance", "audit", "security review", "compliance pack"

## Compliance Package Contents

### 1. Security Controls Document
```markdown
## Security Controls Overview
**Organization:** [Company]
**Date:** [date]
**Version:** [version]

### Authentication & Access
- [ ] MFA enabled for all accounts
- [ ] Password policy: [requirements]
- [ ] Access review frequency: [quarterly/monthly]
- [ ] SSO implementation: [provider]

### Data Protection
- [ ] Encryption at rest: [method]
- [ ] Encryption in transit: TLS 1.2+
- [ ] Data retention policy: [duration]
- [ ] Backup frequency: [schedule]
- [ ] Backup encryption: [yes/no]

### Network Security
- [ ] Firewall configuration
- [ ] VPN for remote access
- [ ] Network segmentation
- [ ] DDoS protection

### Application Security
- [ ] Input validation
- [ ] SQL injection protection
- [ ] XSS protection
- [ ] CSRF protection
- [ ] Dependency scanning

### Monitoring & Logging
- [ ] Centralized logging
- [ ] Log retention: [duration]
- [ ] Alerting configured
- [ ] Incident response plan
```

### 2. Data Processing Inventory
```markdown
## Data Processing Inventory

| Data Type | Source | Purpose | Retention | Legal Basis |
|-----------|--------|---------|-----------|-------------|
| Email addresses | User signup | Account creation | Active + 2y | Consent |
| Payment info | Checkout | Process payment | Transaction | Contract |
| Usage data | App | Analytics | 1 year | Legitimate interest |

### Data Flow Diagram
[Link to diagram]

### Third-Party Processors
| Vendor | Data Shared | Purpose | DPA Signed |
|--------|-------------|---------|------------|
| Stripe | Payment | Processing | Yes |
| AWS | All | Hosting | Yes |
```

### 3. Incident Response Plan
```markdown
## Incident Response Plan

### Severity Levels
**P1 - Critical:** Service down, data breach
**P2 - High:** Major feature broken, security vulnerability
**P3 - Medium:** Minor feature issues, performance degradation
**P4 - Low:** Cosmetic issues, minor bugs

### Response Procedures

#### Detection
- Automated monitoring alerts
- User reports
- Security scanning

#### Triage (Within 15 min)
1. Assess severity
2. Notify on-call engineer
3. Create incident ticket

#### Response
- P1: Immediate all-hands
- P2: Within 1 hour
- P3: Within 4 hours
- P4: Next business day

#### Communication
- Internal: Slack #incidents
- Customers: Status page update
- Regulatory: Within 72 hours if required

#### Post-Incident
- Root cause analysis
- Remediation plan
- Documentation update
```

### 4. Vendor Assessment Checklist
```markdown
## Vendor Security Assessment

**Vendor:** [name]
**Service:** [description]
**Assessment Date:** [date]

### Security Certifications
- [ ] SOC 2 Type II
- [ ] ISO 27001
- [ ] GDPR compliant
- [ ] HIPAA compliant (if applicable)

### Data Handling
- [ ] Data encryption
- [ ] Access controls
- [ ] Audit logging
- [ ] Data deletion capability

### Contractual
- [ ] DPA signed
- [ ] SLA defined
- [ ] Liability terms
- [ ] Termination clause

### Assessment Result
**Risk Level:** Low / Medium / High
**Approved:** Yes / No / Conditional
**Conditions:** [if any]
```

### 5. Access Control Matrix
```markdown
## Access Control Matrix

| Role | System | Access Level | Justification |
|------|--------|--------------|---------------|
| Admin | All | Full | System management |
| Developer | Staging | Full | Development |
| Developer | Production | Read | Debugging |
| Support | CRM | Read/Write | Customer support |
| Analyst | Analytics | Read | Reporting |

### Review Schedule
- Quarterly access reviews
- Immediate review on role change
- Annual full audit
```

## Compliance Frameworks Reference

### SOC 2 Categories
```
- Security
- Availability
- Processing Integrity
- Confidentiality
- Privacy
```

### GDPR Requirements
```
- Lawful basis for processing
- Data subject rights
- Data protection by design
- Breach notification
- Records of processing
- DPO (if required)
```

### ISO 27001 Domains
```
- Information security policies
- Organization of information security
- Human resource security
- Asset management
- Access control
- Cryptography
- Physical security
- Operations security
- Communications security
- System development
- Supplier relationships
- Incident management
- Business continuity
- Compliance
```

---
Last updated: 2026-01-27
