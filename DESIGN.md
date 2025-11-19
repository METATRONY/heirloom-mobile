# Agent Implementation Design Document

## Overview

This document provides step-by-step implementation instructions for building all 13 AI agents in the Heirloom n8n development system.

**Status:** Design Phase
**Total Agents:** 13 (5 implemented + 8 to build)
**Estimated Timeline:** 9 months (Q2-Q4 2025)

---

## Implemented Agents (Reference)

### 1. Project Manager Agent ✅
**File:** `01-project-manager-agent.json`
**Status:** Complete
**Purpose:** Orchestrates workflow, breaks down requirements into tasks

### 2. UI Generator Agent ✅
**File:** `02-ui-generator-agent.json`
**Status:** Complete
**Purpose:** Generates React Native components with tests

### 3. Code Review Agent ✅
**File:** `03-code-review-agent.json`
**Status:** Complete
**Purpose:** Automated PR code reviews

### 4. Backend Integration Agent ✅
**File:** `04-backend-integration-agent.json`
**Status:** Complete
**Purpose:** Generates API service implementations

### 11. Performance Agent ✅
**File:** `11-performance-agent.json`
**Status:** Complete
**Purpose:** Analyzes React Native apps for performance issues and provides AI-powered optimization recommendations
### 5. System Design Agent ✅
**File:** `05-system-design-agent.json`
**Status:** Complete
**Purpose:** Design complete system architecture before development begins

**Key Features:**
- Generates complete system architecture with ASCII diagrams
- Creates database schemas and API architectures
- Plans 3-phase scalability (0-10K, 10K-50K, 50K-100K users)
- Validates budget constraints (±10% tolerance)
- Produces SYSTEM_DESIGN.md documentation
- Auto-creates 3 GitHub implementation issues
- Includes security considerations and compliance

**Usage:** See `SYSTEM_DESIGN_AGENT_USAGE.md` for complete documentation

---

## Agents to Implement

## 5. System Design Agent 📐 (Implementation Reference)

**Priority:** HIGH
**Timeline:** Q2 2025 (April-May) ✅ COMPLETED
**File:** `05-system-design-agent.json` ✅

### Purpose
Design complete system architecture before development begins.

**NOTE:** This agent has been implemented. The sections below are kept for reference.

### Implementation Steps

#### Step 1: Create n8n Workflow (Week 1)

**1.1 Create New Workflow**
```
n8n UI → New Workflow → Name: "05-system-design-agent"
```

**1.2 Add Webhook Trigger**
```javascript
Trigger: Webhook
Method: POST
Path: /webhook/system-design-agent
Response Mode: Last Node
```

**1.3 Expected Input Schema**
```json
{
  "task": "design_system",
  "requirements": "Mobile app with 100K users, real-time features",
  "constraints": {
    "budget": 500,
    "currency": "USD",
    "preferred_tech": ["Firebase", "React Native"]
  },
  "scale": {
    "users": 100000,
    "requests_per_second": 1000,
    "storage_gb": 500
  },
  "compliance": ["GDPR", "HIPAA"],
  "issue_number": 48
}
```

#### Step 2: Build Context Gathering Logic (Week 1-2)

**2.1 Check for Existing Architecture**
```javascript
// Node: "Check Existing Architecture"
// Type: Execute Command
const command = 'find . -name "architecture.md" -o -name "ARCHITECTURE.md"';
```

**2.2 Read Requirements**
```javascript
// Node: "Parse Requirements"
// Type: Code
const requirements = $input.item.json.requirements;
const constraints = $input.item.json.constraints;
const scale = $input.item.json.scale;

return {
  json: {
    parsed_requirements: requirements,
    budget: constraints.budget,
    user_count: scale.users,
    tech_preferences: constraints.preferred_tech
  }
};
```

#### Step 3: Claude AI Integration (Week 2)

**3.1 Create System Prompt**
```javascript
// Node: "Build System Design Prompt"
// Type: Code
const systemPrompt = `You are an expert system architect with 15+ years of experience designing scalable mobile applications.

Your task: Design a complete system architecture based on requirements.

Include:
1. System Architecture Diagram (ASCII)
2. Database Schema (with ERD)
3. API Architecture
4. Technology Stack Recommendations
5. Scalability Plan (3 phases: 0-10K, 10K-50K, 50K-100K users)
6. Cost Estimates (per phase)
7. Performance Targets
8. Security Considerations
9. Infrastructure Design

Format response as JSON with structure:
{
  "architecture_diagram": "ASCII diagram",
  "database_schema": {...},
  "api_architecture": {...},
  "tech_stack": {...},
  "scalability_plan": {...},
  "cost_estimates": {...},
  "performance_targets": {...},
  "security_considerations": [...]
}`;

const userPrompt = `Design a system architecture for:

Requirements: ${$input.item.json.requirements}

Constraints:
- Budget: $${$input.item.json.constraints.budget}/month
- Preferred Tech: ${$input.item.json.constraints.preferred_tech.join(', ')}

Scale:
- Expected Users: ${$input.item.json.scale.users}
- Requests/Second: ${$input.item.json.scale.requests_per_second}
- Storage: ${$input.item.json.scale.storage_gb}GB

Compliance: ${$input.item.json.compliance.join(', ')}`;

return {
  json: {
    system_prompt: systemPrompt,
    user_prompt: userPrompt
  }
};
```

**3.2 Call Claude API**
```javascript
// Node: "Claude AI - Generate Design"
// Type: HTTP Request
Method: POST
URL: https://api.anthropic.com/v1/messages
Headers:
  x-api-key: {{$credentials.AnthropicAPI}}
  anthropic-version: 2023-06-01
  content-type: application/json
Body:
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 8000,
  "system": "{{$node['Build System Design Prompt'].json.system_prompt}}",
  "messages": [{
    "role": "user",
    "content": "{{$node['Build System Design Prompt'].json.user_prompt}}"
  }]
}
```

#### Step 4: Parse and Validate Design (Week 2)

**4.1 Extract Design Document**
```javascript
// Node: "Parse Claude Response"
// Type: Code
const response = $input.item.json.content[0].text;
const design = JSON.parse(response);

return {
  json: {
    architecture_diagram: design.architecture_diagram,
    database_schema: design.database_schema,
    api_architecture: design.api_architecture,
    tech_stack: design.tech_stack,
    scalability_plan: design.scalability_plan,
    cost_estimates: design.cost_estimates,
    performance_targets: design.performance_targets,
    security_considerations: design.security_considerations
  }
};
```

**4.2 Validate Budget Constraints**
```javascript
// Node: "Validate Budget"
// Type: Code
const budget = $input.item.json.constraints.budget;
const estimated_cost = $input.item.json.cost_estimates.phase1.total;

if (estimated_cost > budget * 1.1) {
  throw new Error(`Design exceeds budget: $${estimated_cost} > $${budget}`);
}

return { json: { budget_valid: true } };
```

#### Step 5: Generate Documentation (Week 3)

**5.1 Create Design Document**
```javascript
// Node: "Generate Design Doc"
// Type: Code
const design = $input.item.json;
const markdown = `# System Design Document

**Project:** Heirloom Mobile App
**Date:** ${new Date().toISOString().split('T')[0]}
**Scale:** ${design.scale.users} users

## Architecture Overview

\`\`\`
${design.architecture_diagram}
\`\`\`

## Database Schema

${JSON.stringify(design.database_schema, null, 2)}

## API Architecture

${JSON.stringify(design.api_architecture, null, 2)}

## Technology Stack

${Object.entries(design.tech_stack).map(([key, value]) =>
  `- **${key}**: ${value}`
).join('\n')}

## Scalability Plan

### Phase 1 (0-10K users)
${JSON.stringify(design.scalability_plan.phase1, null, 2)}

### Phase 2 (10K-50K users)
${JSON.stringify(design.scalability_plan.phase2, null, 2)}

### Phase 3 (50K-100K users)
${JSON.stringify(design.scalability_plan.phase3, null, 2)}

## Cost Estimates

| Phase | Monthly Cost |
|-------|--------------|
| Phase 1 | $${design.cost_estimates.phase1.total} |
| Phase 2 | $${design.cost_estimates.phase2.total} |
| Phase 3 | $${design.cost_estimates.phase3.total} |

## Performance Targets

${Object.entries(design.performance_targets).map(([key, value]) =>
  `- ${key}: ${value}`
).join('\n')}

## Security Considerations

${design.security_considerations.map(item => `- ${item}`).join('\n')}
`;

return { json: { markdown, filename: 'SYSTEM_DESIGN.md' } };
```

**5.2 Write to File**
```javascript
// Node: "Write Design File"
// Type: Execute Command
echo "${$node['Generate Design Doc'].json.markdown}" > docs/SYSTEM_DESIGN.md
```

#### Step 6: Create Implementation Tickets (Week 3)

**6.1 Generate GitHub Issues**
```javascript
// Node: "Create Implementation Issues"
// Type: Loop Over Items
// Items:
[
  {
    "title": "Setup Database Schema",
    "body": "Implement database schema from SYSTEM_DESIGN.md",
    "labels": ["infrastructure", "database"]
  },
  {
    "title": "Setup API Scaffolding",
    "body": "Create API structure based on design",
    "labels": ["infrastructure", "api"]
  },
  {
    "title": "Provision Infrastructure",
    "body": "Setup cloud infrastructure as designed",
    "labels": ["infrastructure", "devops"]
  }
]
```

**6.2 Create GitHub Issues**
```javascript
// Node: "Create GitHub Issue"
// Type: HTTP Request
Method: POST
URL: https://api.github.com/repos/{{$json.github_owner}}/{{$json.github_repo}}/issues
Headers:
  Authorization: token {{$credentials.GitHubAPI}}
Body:
{
  "title": "{{$json.title}}",
  "body": "{{$json.body}}",
  "labels": {{$json.labels}}
}
```

#### Step 7: Testing (Week 3-4)

**7.1 Test Input**
```bash
curl -X POST http://localhost:5678/webhook/system-design-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": "design_system",
    "requirements": "Mobile app for audio recording with real-time transcription, 100K users expected",
    "constraints": {
      "budget": 500,
      "currency": "USD",
      "preferred_tech": ["Firebase", "React Native", "Google Cloud"]
    },
    "scale": {
      "users": 100000,
      "requests_per_second": 500,
      "storage_gb": 1000
    },
    "compliance": ["GDPR"],
    "issue_number": 48
  }'
```

**7.2 Expected Output**
- SYSTEM_DESIGN.md file created
- 3 GitHub issues created
- Cost under budget
- Architecture diagram generated

### Success Criteria
- ✅ Generates complete system architecture
- ✅ Stays within budget constraints
- ✅ Creates actionable implementation tickets
- ✅ Design supports 10x growth
- ✅ Includes security considerations

---

## 6. Security Agent 🔒

**Priority:** CRITICAL
**Timeline:** Q3 2025 (July-August)
**File:** `06-security-agent.json`

### Purpose
Automated security audits and vulnerability scanning.

### Implementation Steps

#### Step 1: Create n8n Workflow (Week 1)

**1.1 Create Workflow**
```
n8n UI → New Workflow → Name: "06-security-agent"
```

**1.2 Add Trigger (Schedule + Manual + PR Hook)**
```javascript
// Trigger 1: Schedule (Daily)
Trigger: Cron
Expression: 0 2 * * * (2 AM daily)

// Trigger 2: Manual
Trigger: Webhook
Method: POST
Path: /webhook/security-agent

// Trigger 3: PR Hook
Trigger: GitHub PR Opened
Repository: heirloom-mobile
```

**1.3 Input Schema**
```json
{
  "task": "security_audit",
  "scope": "full",
  "targets": ["src/**/*.ts", "package.json"],
  "issue_number": 47
}
```

#### Step 2: Run Security Scans (Week 1-2)

**2.1 npm audit**
```javascript
// Node: "Run npm audit"
// Type: Execute Command
cd /path/to/project && npm audit --json > /tmp/npm-audit.json
```

**2.2 Snyk Scan**
```javascript
// Node: "Run Snyk"
// Type: Execute Command
cd /path/to/project && snyk test --json > /tmp/snyk-results.json
```

**2.3 Code Analysis (ESLint Security)**
```javascript
// Node: "ESLint Security Check"
// Type: Execute Command
cd /path/to/project && npx eslint . --ext .ts,.tsx --plugin security --format json > /tmp/eslint-security.json
```

**2.4 Check for Hardcoded Secrets**
```javascript
// Node: "Scan for Secrets"
// Type: Execute Command
grep -rE '(password|secret|api_key|token)\s*=\s*["\']' src/ > /tmp/secrets-scan.txt
```

**2.5 License Compliance Scan** 📜 **NEW - CORE FEATURE**
```javascript
// Node: "License Compliance Scan"
// Type: Execute Command
cd /path/to/project && \
npx license-checker --json --production > /tmp/licenses.json && \
npx license-checker --summary
```

```javascript
// Node: "Analyze License Compliance"
// Type: Code
const licenses = JSON.parse(fs.readFileSync('/tmp/licenses.json', 'utf8'));

// Define problematic licenses
const incompatibleLicenses = ['GPL-3.0', 'GPL-2.0', 'AGPL-3.0'];
const restrictedLicenses = ['CC-BY-NC', 'UNLICENSED', 'SEE LICENSE IN LICENSE'];
const approvedLicenses = ['MIT', 'Apache-2.0', 'BSD-3-Clause', 'ISC'];

const issues = [];
const warnings = [];
const summary = {};

Object.entries(licenses).forEach(([pkg, data]) => {
  const license = data.licenses || 'UNKNOWN';

  // Track license types
  summary[license] = (summary[license] || 0) + 1;

  // Check for GPL conflicts (incompatible with proprietary)
  if (incompatibleLicenses.includes(license)) {
    issues.push({
      package: pkg,
      license: license,
      severity: 'critical',
      issue: 'GPL license incompatible with proprietary mobile apps',
      action: 'Replace package or consult legal team'
    });
  }

  // Check for commercial restrictions
  if (restrictedLicenses.some(r => license.includes(r))) {
    warnings.push({
      package: pkg,
      license: license,
      severity: 'high',
      issue: 'License may restrict commercial use',
      action: 'Review license terms manually'
    });
  }

  // Check for missing licenses
  if (!license || license === 'UNKNOWN') {
    warnings.push({
      package: pkg,
      license: 'UNKNOWN',
      severity: 'medium',
      issue: 'Package license not declared',
      action: 'Investigate package repository for license'
    });
  }
});

return {
  json: {
    total_packages: Object.keys(licenses).length,
    license_summary: summary,
    license_issues: issues,
    license_warnings: warnings,
    approved_count: Object.values(summary).reduce((a, b) => a + b, 0)
  }
};
```

**2.6 API Penetration Testing** 🛡️ **NEW - CORE FEATURE**
```javascript
// Node: "API Security Testing"
// Type: Execute Command
# Basic API security tests (non-destructive)
cd /path/to/project && \

# Test 1: SQL Injection patterns
echo "Testing SQL injection..." && \
curl -s -X POST http://localhost:3000/api/test \
  -H "Content-Type: application/json" \
  -d '{"query":"test'"'"' OR '"'"'1'"'"'='"'"'1"}' > /tmp/pentest-sql.json && \

# Test 2: XSS patterns
echo "Testing XSS..." && \
curl -s -X POST http://localhost:3000/api/test \
  -H "Content-Type: application/json" \
  -d '{"input":"<script>alert(1)</script>"}' > /tmp/pentest-xss.json && \

# Test 3: Authentication bypass
echo "Testing auth bypass..." && \
curl -s -X GET http://localhost:3000/api/protected \
  -H "Authorization: Bearer invalid_token_12345" > /tmp/pentest-auth.json && \

# Test 4: IDOR (Insecure Direct Object Reference)
echo "Testing IDOR..." && \
curl -s -X GET http://localhost:3000/api/users/999999 > /tmp/pentest-idor.json && \

# Test 5: Rate limiting
echo "Testing rate limiting..." && \
for i in {1..100}; do
  curl -s -X GET http://localhost:3000/api/test > /dev/null
done && \
curl -s -X GET http://localhost:3000/api/test > /tmp/pentest-ratelimit.json

echo "Pen tests complete"
```

```javascript
// Node: "Analyze Pen Test Results"
// Type: Code
const sqlTest = $node['API Security Testing'].json.sql || {};
const xssTest = $node['API Security Testing'].json.xss || {};
const authTest = $node['API Security Testing'].json.auth || {};
const idorTest = $node['API Security Testing'].json.idor || {};
const rateLimitTest = $node['API Security Testing'].json.ratelimit || {};

const vulnerabilities = {
  critical: [],
  high: [],
  medium: []
};

// Analyze SQL injection test
if (sqlTest.status === 200 || !sqlTest.error) {
  vulnerabilities.critical.push({
    type: 'SQL Injection',
    severity: 'CRITICAL',
    owasp: 'A03:2021 - Injection',
    description: 'Application vulnerable to SQL injection attacks',
    evidence: 'Malicious SQL accepted without sanitization',
    recommendation: 'Use parameterized queries/prepared statements'
  });
}

// Analyze XSS test
if (xssTest.body && xssTest.body.includes('<script>')) {
  vulnerabilities.high.push({
    type: 'Cross-Site Scripting (XSS)',
    severity: 'HIGH',
    owasp: 'A03:2021 - Injection',
    description: 'Application vulnerable to XSS attacks',
    evidence: 'Script tags not sanitized in user input',
    recommendation: 'Implement input sanitization and CSP headers'
  });
}

// Analyze authentication bypass
if (authTest.status === 200) {
  vulnerabilities.critical.push({
    type: 'Broken Authentication',
    severity: 'CRITICAL',
    owasp: 'A07:2021 - Identification and Authentication Failures',
    description: 'Protected endpoints accessible without valid authentication',
    evidence: 'Invalid JWT token accepted',
    recommendation: 'Implement proper JWT validation'
  });
}

// Analyze IDOR
if (idorTest.status === 200 && idorTest.body) {
  vulnerabilities.high.push({
    type: 'IDOR (Insecure Direct Object Reference)',
    severity: 'HIGH',
    owasp: 'A01:2021 - Broken Access Control',
    description: 'Can access other users\' data by ID manipulation',
    evidence: 'User 999999 data returned without authorization',
    recommendation: 'Implement ownership validation before data access'
  });
}

// Analyze rate limiting
if (rateLimitTest.status === 200) {
  vulnerabilities.medium.push({
    type: 'Missing Rate Limiting',
    severity: 'MEDIUM',
    owasp: 'A04:2021 - Insecure Design',
    description: 'No rate limiting on API endpoints',
    evidence: '100 requests accepted without throttling',
    recommendation: 'Implement rate limiting (express-rate-limit)'
  });
}

return {
  json: {
    total_vulnerabilities: vulnerabilities.critical.length + vulnerabilities.high.length + vulnerabilities.medium.length,
    vulnerabilities: vulnerabilities,
    passed_tests: 5 - (vulnerabilities.critical.length + vulnerabilities.high.length + vulnerabilities.medium.length)
  }
};
```

#### Step 3: Analyze with Claude (Week 2)

**3.1 Build Security Prompt**
```javascript
// Node: "Build Security Analysis Prompt"
// Type: Code
const npmAudit = JSON.parse($node['Run npm audit'].json);
const snykResults = JSON.parse($node['Run Snyk'].json);
const eslintResults = JSON.parse($node['ESLint Security Check'].json);
const secretsScan = $node['Scan for Secrets'].json;

const systemPrompt = `You are a senior security engineer specializing in mobile application security.

Analyze comprehensive security scan results including:
- Dependency vulnerabilities
- Code security issues
- Hardcoded secrets
- License compliance issues
- Penetration testing results

Provide:
1. Severity classification (Critical, High, Medium, Low)
2. OWASP mapping
3. Specific fix recommendations with code examples
4. License compliance recommendations
5. Risk assessment

Format response as JSON:
{
  "critical_issues": [...],
  "high_priority_issues": [...],
  "medium_issues": [...],
  "low_issues": [...],
  "license_compliance": {...},
  "penetration_test_summary": {...},
  "compliance_status": {...}
}`;

const userPrompt = `Analyze these security scan results:

npm audit:
${JSON.stringify(npmAudit, null, 2)}

Snyk:
${JSON.stringify(snykResults, null, 2)}

ESLint Security:
${JSON.stringify(eslintResults, null, 2)}

Hardcoded Secrets:
${secretsScan}

License Compliance:
${JSON.stringify($node['Analyze License Compliance'].json, null, 2)}

Penetration Testing Results:
${JSON.stringify($node['Analyze Pen Test Results'].json, null, 2)}`;

return {
  json: {
    system_prompt: systemPrompt,
    user_prompt: userPrompt
  }
};
```

**3.2 Call Claude**
```javascript
// Node: "Claude AI - Security Analysis"
// Type: HTTP Request
Method: POST
URL: https://api.anthropic.com/v1/messages
Body:
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 8000,
  "system": "{{$node['Build Security Analysis Prompt'].json.system_prompt}}",
  "messages": [{
    "role": "user",
    "content": "{{$node['Build Security Analysis Prompt'].json.user_prompt}}"
  }]
}
```

#### Step 4: Generate Security Report (Week 2-3)

**4.1 Create Report**
```javascript
// Node: "Generate Security Report"
// Type: Code
const analysis = JSON.parse($input.item.json.content[0].text);

const report = `# Security Audit Report

**Date:** ${new Date().toISOString()}
**Scope:** Full Application
**Overall Risk:** ${analysis.overall_risk}

## Critical Issues (Fix Immediately) 🔴

${analysis.critical_issues.map((issue, i) => `
### ${i + 1}. ${issue.title}
**File:** ${issue.file}:${issue.line}
**Severity:** Critical
**OWASP:** ${issue.owasp}

**Issue:**
\`\`\`typescript
${issue.vulnerable_code}
\`\`\`

**Fix:**
\`\`\`typescript
${issue.fixed_code}
\`\`\`

**Impact:** ${issue.impact}
`).join('\n---\n')}

## High Priority Issues 🟡

${analysis.high_priority_issues.map((issue, i) => `
### ${i + 1}. ${issue.title}
**File:** ${issue.file}:${issue.line}
**Severity:** High
**Fix:** ${issue.fix}
`).join('\n---\n')}

## Dependencies Report

| Package | Current | Latest | Vulnerabilities |
|---------|---------|--------|-----------------|
${analysis.dependencies.map(dep =>
  `| ${dep.name} | ${dep.current} | ${dep.latest} | ${dep.vulns} |`
).join('\n')}

## Recommendations

${analysis.recommendations.map((rec, i) => `${i + 1}. ${rec}`).join('\n')}

## Compliance Status

- OWASP Top 10: ${analysis.compliance_status.owasp_top10}/10 passed
- OWASP Mobile Top 10: ${analysis.compliance_status.owasp_mobile}/10 passed
- GDPR: ${analysis.compliance_status.gdpr ? '✅' : '⚠️'}
`;

return { json: { report, filename: 'SECURITY_AUDIT.md' } };
```

#### Step 5: Auto-Fix Simple Issues (Week 3)

**5.1 Update Dependencies**
```javascript
// Node: "Update Vulnerable Dependencies"
// Type: Execute Command
cd /path/to/project && npm update && npm audit fix
```

**5.2 Add Security Headers**
```javascript
// Node: "Add Security Headers"
// Type: Code/File Write
// Add to API middleware:
const securityHeaders = `
app.use((req, res, next) => {
  res.setHeader('X-Content-Type-Options', 'nosniff');
  res.setHeader('X-Frame-Options', 'DENY');
  res.setHeader('X-XSS-Protection', '1; mode=block');
  res.setHeader('Strict-Transport-Security', 'max-age=31536000');
  next();
});
`;
```

#### Step 6: Create PR with Fixes (Week 3-4)

**6.1 Create Branch & Commit**
```javascript
// Node: "Create Security Fix Branch"
// Type: Execute Command
cd /path/to/project && \
git checkout -b security/automated-fixes-$(date +%Y%m%d) && \
git add . && \
git commit -m "security: Automated security fixes

- Updated vulnerable dependencies
- Added security headers
- Fixed hardcoded secrets

Security audit report: SECURITY_AUDIT.md" && \
git push -u origin HEAD
```

**6.2 Create PR**
```javascript
// Node: "Create Security PR"
// Type: HTTP Request
Method: POST
URL: https://api.github.com/repos/{{$json.github_owner}}/{{$json.github_repo}}/pulls
Body:
{
  "title": "🔒 Security: Automated Security Fixes",
  "head": "security/automated-fixes-{{$json.date}}",
  "base": "main",
  "body": "## Security Audit Results\n\n{{$node['Generate Security Report'].json.report}}"
}
```

### Success Criteria
- ✅ Detects all OWASP Top 10 vulnerabilities
- ✅ Scans dependencies for CVEs
- ✅ **Scans all open source licenses for compliance** 📜 **NEW**
- ✅ **Detects GPL conflicts and commercial restrictions** 📜 **NEW**
- ✅ **Performs API penetration testing** 🛡️ **NEW**
- ✅ **Tests for SQL injection, XSS, auth bypass, IDOR** 🛡️ **NEW**
- ✅ Auto-fixes simple issues
- ✅ Generates comprehensive security report
- ✅ Creates PR with fixes

### 📋 Optional Enhancements (Post-Merge)

These can be added in future iterations:

#### Sprint 2 (Optional)
- [ ] Add React Native specific security checks
  - AsyncStorage encryption validation
  - Deep linking security
  - JavaScript bridge exposure
  - WebView security (allowFileAccess, allowUniversalAccessFromFileURLs)
  - Native module security
  - Certificate pinning implementation
  - Root/jailbreak detection
- [ ] Document Snyk authentication requirement
- [ ] Add iOS/Android platform-specific scans
  - **iOS:** Keychain implementation, certificate pinning, jailbreak detection
  - **Android:** ProGuard/R8 obfuscation, root detection, encrypted SharedPreferences
- [ ] Implement PR blocking on critical issues

#### Sprint 3 (Optional)
- [ ] Add API security testing
  - Authentication bypass testing
  - IDOR detection
  - Rate limiting validation
  - Input validation testing
- [ ] Implement CI/CD pipeline security checks
  - GitHub Actions workflow security
  - Secret scanning in workflows
  - Third-party action auditing
  - Branch protection validation
- [ ] Add compliance automation (PII detection)
  - PII detection in logs
  - GDPR data retention validation
  - User consent tracking
  - Data encryption verification
- [ ] Create security metrics dashboard
- [ ] Add supply chain security
  - Package integrity verification
  - Typosquatting detection
  - Dependency confusion detection
  - License compliance
- [ ] Real CVE integration
  - CVE database lookups
  - CVSS score tracking
  - Vulnerability aging tracking

### 🚀 Deployment Checklist

Before deploying to production:

#### Configuration
- [ ] Set up Anthropic API credentials in n8n
- [ ] Configure GitHub API credentials
- [ ] Set up Snyk authentication (if using Snyk)
- [ ] Configure webhook URLs

#### Testing
- [ ] Test with a real repository
- [ ] Verify input validation (try malicious inputs)
- [ ] Confirm secrets detection works
- [ ] Test PR creation flow
- [ ] Verify webhook responses

#### Documentation
- [ ] Add setup guide to README
- [ ] Document required credentials
- [ ] Create troubleshooting guide
- [ ] Document Snyk setup

#### Monitoring
- [ ] Set up n8n execution logging
- [ ] Configure error notifications
- [ ] Monitor Claude API usage/costs
- [ ] Track false positive rate

---

## 7. Testing Agent 🧪 ✅ IMPLEMENTED

**Priority:** HIGH
**Status:** Complete
**File:** `07-testing-agent.json`

### Purpose
Automatically generates comprehensive test suites for React Native components and modules using AI.

### Implementation Complete

#### Workflow Structure (15 nodes)
1. ✅ Webhook trigger `/webhook/testing-agent`
2. ✅ Read target file content
3. ✅ Check existing tests
4. ✅ Analyze current coverage
5. ✅ Generate tests with Claude AI
6. ✅ Parse generated test code
7. ✅ Write test files
8. ✅ Run Jest tests
9. ✅ Validate test results
10. ✅ Create Git branch
11. ✅ Commit test files
12. ✅ Create PR with coverage report
13. ✅ Handle test failures

#### Input Schema
```json
{
  "target": "src/components/Button.tsx",
  "test_types": ["unit", "e2e", "accessibility"],
  "issue_number": 12,
  "github_owner": "your-username",
  "github_repo": "heirloom-mobile"
}
```

#### Features
- Analyzes code structure to identify all testable units
- Generates tests for all public functions, methods, and props
- Includes edge cases and error scenarios
- Tests accessibility features (WCAG 2.1 compliance)
- Uses Jest and React Testing Library
- Targets 90%+ code coverage
- Creates PR with detailed coverage report
- Handles test failures gracefully

### Success Criteria
- ✅ Generates comprehensive test suites
- ✅ Achieves 90%+ code coverage
- ✅ Tests all edge cases
- ✅ Includes accessibility tests
- ✅ Creates PR with coverage report

---

## 8. Documentation Agent 📚

**Priority:** MEDIUM
**Timeline:** Q2 2025 (June)
**File:** `08-documentation-agent.json`

### Implementation Steps

#### Step 1: Trigger on Code Changes
1. Git webhook on commit
2. Detect changed files
3. Filter for code files

#### Step 2: Extract Documentation Data
1. Parse TypeScript types
2. Extract function signatures
3. Get component props
4. Find usage examples

#### Step 3: Generate Docs with Claude
1. Create API reference
2. Generate usage guides
3. Update CHANGELOG
4. Add inline comments

#### Step 4: Deploy Documentation
1. Commit doc files
2. Deploy to docs site
3. Update links

---

## 9. API Design Agent 🌐

**Priority:** MEDIUM
**Timeline:** Q3 2025 (September)
**File:** `09-api-design-agent.json`

### Implementation Steps

#### Step 1: Requirements Gathering
1. Accept feature description
2. Identify resources
3. Map relationships
4. Determine access patterns

#### Step 2: Design API with Claude
1. Generate endpoint structure
2. Design request/response schemas
3. Define authentication
4. Create rate limiting rules

#### Step 3: Generate OpenAPI Spec
1. Create Swagger/OpenAPI YAML
2. Add examples
3. Document authentication
4. Include error responses

#### Step 4: Create PR
1. Commit OpenAPI spec
2. Generate implementation guide
3. Update README

---

## 10-13. Remaining Agents

### 10. Deploy Agent (Q3 2025)
- Fastlane integration
- App store automation
- Build generation

### 11. Performance Agent ✅ (Implemented)
**File:** `11-performance-agent.json`
- React DevTools profiling ✅
- Bundle analysis ✅
- Memory leak detection ✅
- AI-powered optimization recommendations ✅
- Performance scoring (render, bundle, memory) ✅
- Automated GitHub issue creation ✅

### 12. Refactoring Agent (Q4 2025)
- Code smell detection
- Component extraction
- Complexity analysis

### 13. Translation Agent 🌐

**Priority:** MEDIUM
**Timeline:** Q4 2025 (October-November)
**File:** `13-translation-agent.json`

#### Purpose
Automated internationalization (i18n) for React Native apps with specialized Hebrew/English support for elderly users.

#### Implementation Steps

##### Step 1: Create n8n Workflow (Week 1)

**1.1 Create New Workflow**
```
n8n UI → New Workflow → Name: "13-translation-agent"
```

**1.2 Add Webhook Trigger**
```javascript
Trigger: Webhook
Method: POST
Path: /webhook/translation-agent
Response Mode: Last Node
```

**1.3 Expected Input Schema**
```json
{
  "task": "Extract and translate strings",
  "github_owner": "METATRONY",
  "github_repo": "heirloom-mobile",
  "target_languages": ["en", "he"],
  "issue_number": 9
}
```

##### Step 2: Scan Source Files (Week 1)

**2.1 Find All React Native Files**
```javascript
// Node: "Scan Source Files"
// Type: Execute Command
const command = 'find ./src -name "*.tsx" -o -name "*.ts" | grep -v "__tests__" | xargs cat';
```

**2.2 Load Existing Translations**
```javascript
// Node: "Load Existing Translations"
// Type: Execute Command
const command = 'cat ./src/locales/en.json ./src/locales/he.json 2>/dev/null || echo "{}"';
```

##### Step 3: Extract and Translate with Claude (Week 1-2)

**3.1 Build Translation Prompt**
```javascript
// Node: "Extract & Translate (Claude)"
// Type: HTTP Request
const systemPrompt = `You are an expert in internationalization (i18n) for React Native applications, specializing in:
- String extraction from JSX and TypeScript code
- Hebrew and English translation (bidirectional)
- RTL (Right-to-Left) and LTR layout considerations
- Cultural and linguistic nuances for elderly Hebrew speakers
- react-i18next and i18n best practices
- Accessibility in multiple languages

You provide accurate, culturally appropriate translations and identify UI elements that need RTL adjustments.`;

const userPrompt = `Analyze this React Native codebase and extract all translatable strings.

**Source Code:**
${sourceCode}

**Existing Translations:**
${existingTranslations}

**Target Languages:** English (en), Hebrew (he)

**Instructions:**
1. Extract all user-facing strings (text in JSX, button labels, error messages, placeholders)
2. Ignore code strings (imports, function names, variable names)
3. Create unique translation keys: 'screen.section.element'
4. Translate to Hebrew with cultural sensitivity for elderly users
5. Identify components needing RTL layout fixes
6. Generate updated component code with i18n hooks
7. Provide migration guide

Return JSON format:
{
  "translations": {
    "en": { "key": "English text", ... },
    "he": { "key": "טקסט בעברית", ... }
  },
  "rtl_fixes": [...],
  "updated_files": [...],
  "new_strings_count": 42,
  "migration_guide": "..."
}`;
```

**3.2 Call Claude API**
```javascript
// Node: "Extract & Translate (Claude)"
// Type: HTTP Request
Method: POST
URL: https://api.anthropic.com/v1/messages
Body:
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 8000,
  "system": "{{systemPrompt}}",
  "messages": [{
    "role": "user",
    "content": "{{userPrompt}}"
  }]
}
```

##### Step 4: Generate Translation Files (Week 2)

**4.1 Parse Response**
```javascript
// Node: "Parse Translation Data"
// Type: Code
const response = $input.item.json.content[0].text;
const data = JSON.parse(response);

return {
  json: {
    translation_data: data
  }
};
```

**4.2 Write Translation Files**
```javascript
// Node: "Write English Translations"
// Type: Execute Command
mkdir -p ./src/locales
echo '${JSON.stringify(data.translations.en, null, 2)}' > ./src/locales/en.json

// Node: "Write Hebrew Translations"
// Type: Execute Command
echo '${JSON.stringify(data.translations.he, null, 2)}' > ./src/locales/he.json
```

##### Step 5: Update Components with i18n (Week 2-3)

**5.1 Loop Through Updated Files**
```javascript
// Node: "Loop Updated Files"
// Type: Split In Batches
// Items: $json.translation_data.updated_files
```

**5.2 Write Updated Components**
```javascript
// Node: "Write Updated File"
// Type: Execute Command
echo '${$json.file.content}' > ${$json.file.path}
```

##### Step 6: Create PR with Changes (Week 3)

**6.1 Create Git Branch**
```javascript
// Node: "Create Git Branch"
// Type: Execute Command
git checkout -b translations/ai-translation-$(date +%Y%m%d-%H%M%S)
```

**6.2 Commit Changes**
```javascript
// Node: "Git Commit"
// Type: Execute Command
git add src/locales/ src/components/ src/screens/
git commit -m "i18n: Add AI-generated translations and RTL fixes

- Added ${translation_data.new_strings_count} translation strings
- English and Hebrew translations
- Fixed ${translation_data.rtl_fixes.length} RTL layout issues
- Updated components with react-i18next hooks

Generated by Translation Agent"
```

**6.3 Push and Create PR**
```javascript
// Node: "Git Push"
// Type: Execute Command
git push -u origin HEAD

// Node: "Create Pull Request"
// Type: GitHub Node
{
  "title": "🌐 i18n: Add translations and RTL support",
  "body": "## Translation Summary\n\n**Generated by:** Translation Agent (AI)\n...",
  "labels": ["i18n", "translation", "rtl", "automated"]
}
```

##### Step 7: Generate Documentation (Week 3-4)

**7.1 Generate i18n Guide**
```javascript
// Node: "Generate Documentation (Claude)"
// Type: HTTP Request
const prompt = `Create a comprehensive i18n setup guide based on these changes:

${JSON.stringify(translation_data, null, 2)}

Include:
1. Quick start guide
2. How to add new translations
3. RTL testing guide
4. Best practices for elderly users
5. Troubleshooting common issues

Format as Markdown.`;
```

**7.2 Write Documentation**
```javascript
// Node: "Write Documentation"
// Type: Execute Command
echo '${documentation}' > ./docs/I18N_GUIDE.md
```

##### Step 8: Testing (Week 4)

**8.1 Test Input**
```bash
curl -X POST http://localhost:5678/webhook/translation-agent \
  -H "Content-Type: application/json" \
  -d @test/fixtures/translation-agent-input.json
```

**8.2 Expected Output**
- Translation files created (`en.json`, `he.json`)
- Components updated with `useTranslation()` hooks
- RTL fixes applied (flexDirection, textAlign, padding)
- PR created with comprehensive description
- Documentation generated

#### Success Criteria
- ✅ Extracts all user-facing strings from React Native code
- ✅ Generates accurate English and Hebrew translations
- ✅ Identifies and fixes RTL layout issues
- ✅ Updates components with react-i18next integration
- ✅ Creates PR with migration guide
- ✅ Execution time under 2 minutes
- ✅ Cost under $0.30 per run
- ✅ Hebrew translations culturally appropriate for elderly users

#### RTL Fix Examples

**Before:**
```typescript
const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    paddingLeft: 20,
    textAlign: 'left'
  }
});
```

**After:**
```typescript
import { I18nManager } from 'react-native';

const styles = StyleSheet.create({
  container: {
    flexDirection: I18nManager.isRTL ? 'row-reverse' : 'row',
    paddingStart: 20,
    textAlign: I18nManager.isRTL ? 'right' : 'left'
  }
});
```

#### Translation Key Structure

```json
{
  "auth.login.title": "Welcome Back",
  "auth.login.emailPlaceholder": "Enter your email",
  "auth.login.submitButton": "Log In",
  "common.cancel": "Cancel",
  "common.save": "Save",
  "errors.network": "Network connection error"
}
```

#### Hebrew Translation Examples

```json
{
  "auth.login.title": "ברוכים השבים",
  "auth.login.emailPlaceholder": "הזן את כתובת הדוא״ל שלך",
  "auth.login.submitButton": "התחבר",
  "common.cancel": "ביטול",
  "common.save": "שמור",
  "errors.network": "שגיאת חיבור לרשת"
}
```

---

## Implementation Timeline

| Agent | Q2 2025 | Q3 2025 | Q4 2025 |
|-------|---------|---------|---------|
| System Design | ✅ DONE | | |
| Testing | ░░████ | | |
| Documentation | ░░░░██ | | |
| Security | | ████░░ | |
| API Design | | ░░████ | |
| Deploy | | ░░░░██ | |
| Performance | | ✅ Complete | |
| Refactoring | | | ████░░ |
| Translation | | | ░░████ |

---

## Development Checklist

### For Each Agent

- [ ] Create n8n workflow file
- [ ] Add webhook trigger
- [ ] Define input/output schema
- [ ] Build Claude AI integration
- [ ] Add error handling
- [ ] Write test cases
- [ ] Create documentation
- [ ] Deploy to production
- [ ] Monitor performance
- [ ] Collect feedback

---

## Testing Strategy

### Unit Testing
```bash
# Test individual nodes
n8n test workflow-id --node="Node Name"
```

### Integration Testing
```bash
# Test complete workflow
curl -X POST http://localhost:5678/webhook/agent-name \
  -H "Content-Type: application/json" \
  -d @test/fixtures/input.json
```

### End-to-End Testing
```bash
# Test with real GitHub repo
./scripts/e2e-test-agent.sh agent-name
```

---

## Deployment Process

1. **Development**
   - Build in local n8n instance
   - Test with sample data

2. **Staging**
   - Deploy to staging environment
   - Run integration tests
   - Validate with real repos

3. **Production**
   - Export workflow JSON
   - Import to production n8n
   - Activate workflow
   - Monitor execution

4. **Monitoring**
   - Track execution success rate
   - Monitor API costs
   - Collect user feedback
   - Iterate and improve

---

## Cost Management

### Claude API Budget
- Development: $10/month
- Testing: $20/month
- Production: $50-100/month

### Total Monthly Cost
- All 13 agents running: $50-120/month
- vs Traditional team: $26,000/month
- **Savings: 99.5%**

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Code generation speed | 10-20x faster |
| Test coverage | 90%+ |
| Security vulnerabilities | 0 critical |
| Documentation coverage | 100% |
| Deployment time | < 10 minutes |
| Developer productivity | 95%+ improvement |

---

**Last Updated:** 2025-11-18
**Status:** Active Development
**Completed:** System Design Agent ✅
**Next Steps:** Begin Testing Agent (Week 1, May 2025)
