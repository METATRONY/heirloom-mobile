# Production Requirements for Deploy Agent

## ⚠️ CRITICAL: This Workflow is Currently a DEMO

**Current Status:** Prototype/Demonstration  
**Production Ready:** NO (approximately 40% complete)  
**Safe for Production Use:** NO - Builds and uploads are simulated

---

## What is Real vs. Simulated

### ✅ Real & Working
- Input validation and sanitization
- Authentication via API keys (when configured)
- Claude AI release notes generation
- GitHub issue commenting
- Workflow logic and routing
- Error handling and fallback mechanisms
- Deployment report generation

### ⚠️ Simulated (NOT Real)
- **Build execution** - No actual Fastlane or Gradle commands run
- **App store uploads** - No .ipa or .aab files are uploaded
- **Git tags** - Tags are not created in the repository
- **Pre-flight checks** - Always pass, no real tests executed
- **Code signing** - Not verified or used
- **Build artifacts** - URLs and sizes are simulated

---

## Before Production Use - REQUIRED CHANGES

### 1. Authentication Setup (CRITICAL)

**Current State:** Basic API key authentication implemented but requires configuration.

**Required Action:**
```bash
# Set environment variable in n8n
export DEPLOYMENT_API_KEYS="your-secret-key-1,your-secret-key-2,backup-key"
```

**Alternative Options:**
1. **n8n Built-in Auth** - Enable webhook authentication in n8n settings
2. **IP Whitelisting** - Configure n8n to only accept requests from trusted IPs
3. **OAuth/JWT** - Implement token-based authentication (requires additional nodes)

**Risk if Not Configured:** Anyone who knows your webhook URL can trigger deployments

---

### 2. Real Build Execution (CRITICAL)

**What Needs Implementation:**

#### iOS Builds
Replace the "Build iOS (Fastlane)" node code execution with:

```javascript
// Node Type: n8n-nodes-base.executeCommand
{
  "command": "cd /path/to/ios/project && fastlane ios {{ $json.environment }}",
  "options": {
    "timeout": 600000,  // 10 minutes
    "cwd": "/path/to/project"
  }
}
```

**Follow-up Nodes Needed:**
- Parse Fastlane output for actual build number
- Extract real bundle size from .ipa file
- Verify build succeeded (check exit code)
- Upload .ipa to TestFlight/App Store Connect

#### Android Builds
Replace the "Build Android (Gradle)" node code execution with:

```javascript
// Node Type: n8n-nodes-base.executeCommand
{
  "command": "cd /path/to/android/project && ./gradlew bundle{{ $json.environment == 'beta' ? 'Release' : 'Production' }}",
  "options": {
    "timeout": 600000,  // 10 minutes
    "cwd": "/path/to/project"
  }
}
```

**Follow-up Nodes Needed:**
- Parse Gradle output for actual build number
- Extract real bundle size from .aab file
- Verify build succeeded (check exit code)
- Upload .aab to Google Play Console

---

### 3. Real Pre-flight Checks (CRITICAL)

**Current State:** All checks hardcoded to return `true`

**Required Implementation:**

#### Test Execution
```javascript
// Node: Run Tests
// Type: n8n-nodes-base.executeCommand
{
  "command": "cd /path/to/project && npm test",
  "options": {
    "timeout": 300000  // 5 minutes
  }
}

// Node: Verify Tests Passed
// Type: n8n-nodes-base.code
if ($input.item.json.exitCode !== 0) {
  throw new Error('Tests failed. Cannot proceed with deployment.');
}
```

#### Version Tag Check
```javascript
// Node: Check Version Tag
// Type: n8n-nodes-base.executeCommand
{
  "command": "git tag -l v{{ $json.version }}"
}

// Node: Validate Tag Doesn't Exist
// Type: n8n-nodes-base.code
const tagExists = $input.item.json.stdout.trim().length > 0;
if (tagExists) {
  throw new Error('Version tag v' + $json.version + ' already exists!');
}
```

#### Changelog Verification
```javascript
// Node: Check Changelog
// Type: n8n-nodes-base.executeCommand
{
  "command": "grep -q '## \\[{{ $json.version }}\\]' CHANGELOG.md"
}
```

#### Security Scan
```javascript
// Node: Run Security Audit
// Type: n8n-nodes-base.executeCommand
{
  "command": "npm audit --audit-level=high"
}
```

---

### 4. Real Git Operations

**Current State:** Git tags are not created, only simulated

**Required Implementation:**

```javascript
// Node: Create Git Tag
// Type: n8n-nodes-base.executeCommand
{
  "command": "git tag -a v{{ $json.version }} -m 'Release {{ $json.version }} for {{ $json.platform }} {{ $json.environment }}' && git push origin v{{ $json.version }}"
}

// Node: Verify Tag Created
// Type: n8n-nodes-base.executeCommand
{
  "command": "git tag -l v{{ $json.version }}"
}
```

**Requirements:**
- Git credentials configured (SSH keys or HTTPS token)
- Write access to repository
- Tag push permissions

---

### 5. Rollback Mechanism (HIGH PRIORITY)

**Not Currently Implemented**

**Required Features:**
1. Store previous version information
2. Create rollback workflow/nodes
3. Ability to revert to previous App Store/Play Store version
4. Git tag rollback (delete tag, revert commits if needed)
5. Notification of rollback completion

**Suggested Implementation:**
- Create separate "Rollback Deploy Agent" workflow
- Store deployment metadata in database
- Link rollback trigger to monitoring alerts

---

### 6. Monitoring & Alerts (HIGH PRIORITY)

**Not Currently Implemented**

**Required Integration:**

#### Slack Notifications
```javascript
// Node: Send Slack Notification
// Type: n8n-nodes-base.slack
{
  "channel": "#deployments",
  "text": "🚀 Deployment {{ $json.version }} to {{ $json.environment }} {{ $json.status }}\nPlatform: {{ $json.platform }}\nTime: {{ $json.deployment_time_minutes }} minutes"
}
```

#### Email Alerts
```javascript
// Node: Send Email on Failure
// Type: n8n-nodes-base.emailSend
// Trigger: Only on deployment failure
{
  "to": "dev-team@company.com",
  "subject": "❌ Deployment Failed: {{ $json.version }}",
  "text": "Deployment to {{ $json.environment }} failed. Check logs."
}
```

#### Monitoring Dashboard
- Log all deployments to database
- Track success/failure rates
- Monitor deployment duration
- Alert on anomalies

---

## Required Environment Variables

Set these in your n8n environment:

```bash
# Authentication (REQUIRED for production)
export DEPLOYMENT_API_KEYS="key1,key2,key3"

# Project Paths (REQUIRED for real builds)
export IOS_PROJECT_PATH="/path/to/ios/project"
export ANDROID_PROJECT_PATH="/path/to/android/project"

# App Store Credentials (REQUIRED for uploads)
export FASTLANE_USER="apple-id@example.com"
export FASTLANE_PASSWORD="app-specific-password"
export FASTLANE_APPLE_TEAM_ID="TEAM123"

# Google Play Credentials (REQUIRED for uploads)
export GOOGLE_PLAY_JSON_KEY="/path/to/google-play-key.json"

# Notification Settings (OPTIONAL but recommended)
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/..."
export DEPLOYMENT_EMAIL_ALERTS="team@company.com"

# Git Configuration (REQUIRED for tags)
export GIT_USER_NAME="Deploy Bot"
export GIT_USER_EMAIL="deploy-bot@company.com"
```

---

## Required n8n Credentials

Configure these in n8n Credentials panel:

1. **Anthropic API** (anthropicApi)
   - API Key from anthropic.com

2. **GitHub API** (githubCredentials)
   - Personal Access Token with repo scope

3. **Slack** (optional, for notifications)
   - Webhook URL or OAuth token

4. **Email** (optional, for alerts)
   - SMTP credentials

---

## Security Checklist

Before deploying to production:

- [ ] **Authentication configured** - API keys set in environment
- [ ] **HTTPS only** - Webhook URL uses HTTPS
- [ ] **Rate limiting** - Configure n8n rate limits on webhook
- [ ] **IP whitelisting** (optional) - Restrict to known IPs
- [ ] **Audit logging** - Enable n8n execution logging
- [ ] **Secrets management** - Use n8n credentials, not hardcoded values
- [ ] **Access control** - Limit who can trigger production deployments
- [ ] **Code signing certificates** - Valid and not expired
- [ ] **App store credentials** - Secured and rotated regularly
- [ ] **Git credentials** - Use SSH keys or secure tokens

---

## Testing Checklist

Before production deployment:

### Phase 1: Local Testing
- [ ] Test input validation with invalid inputs
- [ ] Test authentication with valid/invalid keys
- [ ] Test platform routing (ios, android, both)
- [ ] Test error handling (network failures, API errors)

### Phase 2: Staging Deployment
- [ ] Deploy to staging environment
- [ ] Test with real Fastlane commands (staging certificates)
- [ ] Test with real Gradle builds
- [ ] Verify pre-flight checks work correctly
- [ ] Test rollback procedure

### Phase 3: Production Readiness
- [ ] Document all configuration requirements
- [ ] Train team on using the deployment workflow
- [ ] Set up monitoring and alerts
- [ ] Create runbook for common issues
- [ ] Plan maintenance windows

---

## Cost Estimates

### Demo Version (Current)
- Claude API: ~$0.01 per deployment
- n8n execution: Free (self-hosted) or minimal (cloud)
- **Total: ~$0.01-0.05 per deployment**

### Production Version (with real builds)
- Claude API: ~$0.01
- Build infrastructure: ~$0.10-0.20 (compute time)
- Storage (artifacts): ~$0.05
- Monitoring/logging: ~$0.05
- **Total: ~$0.20-0.35 per deployment**

### Monthly Estimates
- 10 deploys/week (40/month): ~$8-14/month
- 25 deploys/week (100/month): ~$20-35/month
- With full monitoring suite: Add $20-50/month

---

## Migration Path: Demo → Production

### Week 1: Foundation
1. Set up authentication (API keys)
2. Configure environment variables
3. Test webhook authentication
4. Document access procedures

### Week 2: Build Integration
1. Implement real iOS build (Fastlane)
2. Implement real Android build (Gradle)
3. Test builds in staging
4. Verify build artifacts

### Week 3: Pre-flight Checks
1. Implement real test execution
2. Implement version tag verification
3. Implement changelog checks
4. Implement security scanning

### Week 4: Upload & Deploy
1. Implement real TestFlight upload
2. Implement real Google Play upload
3. Verify uploads work correctly
4. Test end-to-end deployment

### Week 5: Operations
1. Implement git tag creation
2. Set up monitoring and alerts
3. Configure Slack notifications
4. Test rollback procedures

### Week 6: Production Launch
1. Final security audit
2. Team training
3. Gradual rollout (beta first)
4. Monitor and iterate

---

## Support & Escalation

### For Issues:
1. Check n8n execution logs
2. Review DEPLOY_AGENT_README.md
3. Verify environment variables set
4. Check credential configuration

### Emergency Contacts:
- **Deployment failures:** Check Slack #deployments channel
- **Security issues:** Alert security team immediately
- **Build failures:** Check build logs in n8n execution details

---

## Revision History

- **2025-11-18:** Initial production requirements document
- **Status:** Demo/Prototype - NOT production ready
- **Next Review:** After implementing real builds (Phase 2)

---

**REMEMBER:** This workflow is currently a DEMO. Do not use for production deployments until all critical requirements are implemented and tested.
