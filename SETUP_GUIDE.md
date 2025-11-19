# Heirloom Mobile App - n8n Agent System Setup Guide

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Initial Setup](#initial-setup)
3. [n8n Configuration](#n8n-configuration)
4. [Agent Workflows](#agent-workflows)
5. [Project Structure](#project-structure)
6. [Running the System](#running-the-system)
7. [Monitoring & Debugging](#monitoring--debugging)
8. [Cost Management](#cost-management)

---

## 1. Prerequisites

### Software Requirements
```bash
# Node.js 18+ and npm
node --version  # Should be 18+
npm --version

# Git
git --version

# Docker (optional, for containerized n8n)
docker --version

# React Native CLI
npm install -g react-native-cli

# n8n
npm install -g n8n
```

### Required Accounts & API Keys

1. **Anthropic Claude API**
   - Sign up: https://console.anthropic.com
   - Create API key: https://console.anthropic.com/settings/keys
   - Pricing: ~$3 per million input tokens, ~$15 per million output tokens

2. **GitHub**
   - ⚠️ **SECURITY**: Use **fine-grained personal access tokens** (not classic tokens)
   - Generate: https://github.com/settings/tokens/new?type=beta
   - **Minimal required permissions**:
     - Repository: `contents:write`, `pull_requests:write`, `issues:write`
     - ⚠️ **DO NOT grant**: `workflow`, `admin:repo_hook`, or `delete_repo` permissions
   - Set expiration: 90 days maximum
   - Rotate tokens regularly

3. **Firebase** (Already have this)
   - Project ID
   - Service account JSON

4. **Google Cloud Platform** (Already have this)
   - Speech-to-Text API enabled
   - Cloud Storage bucket

---

## 2. Initial Setup

### Step 1: Create Project Repository

```bash
# Create new React Native project

npx react-native init HeirloomMobile --template react-native-template-typescript

cd HeirloomMobile

# If you do not see the ios/ folder after init, the project was not created correctly.
# Troubleshooting:
# - Make sure you are not inside an existing folder with a package.json.
# - Delete the folder and re-run the init command above.
# - If you want to add iOS support to an existing project:
npx react-native upgrade
npx react-native eject  # Only if using Expo

# Note:
# - `npx react-native upgrade` updates React Native and template files.
# - Your custom code in `src/` is not affected, but you may need to resolve merge conflicts in config/native files.
# - Always commit your code before upgrading.
# - After upgrade, run `npm install` and `cd ios && pod install` if using iOS.

# Initialize git repository
git init
git add .
git commit -m "Initial commit"

# Create GitHub repository and push
gh repo create heirloom-mobile --public --source=. --push
# Or manually create on GitHub and:
git remote add origin https://github.com/YOUR_USERNAME/heirloom-mobile.git
git push -u origin main
```

### Step 2: Project Structure Setup

```bash
# Create directory structure
mkdir -p src/{components,screens,navigation,services,store,utils,types,styles}
mkdir -p src/screens/__tests__
mkdir -p src/components/__tests__

# Create configuration files
touch src/styles/theme.ts
touch src/utils/accessibility.ts
touch src/services/api.ts
touch src/services/audio.ts
touch src/services/stt.ts
touch src/services/tts.ts
```

### Step 3: Install Dependencies

```bash
# Core dependencies
npm install @react-navigation/native @react-navigation/stack
npm install @reduxjs/toolkit react-redux redux-persist
npm install @react-native-firebase/app @react-native-firebase/auth
npm install @react-native-firebase/firestore @react-native-firebase/storage
npm install axios react-native-sound
npm install react-native-audio-recorder-player
npm install @react-native-community/audio-toolkit
npm install react-native-fs
npm install i18next react-i18next

# Dev dependencies
npm install --save-dev @testing-library/react-native
npm install --save-dev @testing-library/jest-native
npm install --save-dev jest-expo
npm install --save-dev @types/react @types/react-native

# iOS specific
cd ios && pod install && cd ..
# If you get "No such file or directory", make sure the ios/ folder exists.
# See troubleshooting above.
```

### Step 4: Create Base Files

**src/styles/theme.ts**
```typescript
export const theme = {
  colors: {
    primary: '#2E7D32',
    secondary: '#1565C0',
    background: '#FFFFFF',
    backgroundDark: '#121212',
    text: '#000000',
    textDark: '#FFFFFF',
    error: '#D32F2F',
    success: '#388E3C',
    warning: '#F57C00',
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  },
  fontSize: {
    small: 16,
    medium: 20,
    large: 24,
    xlarge: 32,
  },
  accessibility: {
    minTouchTarget: 44,
    contrastRatio: 4.5,
  },
};
```

**src/utils/accessibility.ts**
```typescript
import { AccessibilityInfo } from 'react-native';

export const announceForAccessibility = (message: string) => {
  AccessibilityInfo.announceForAccessibility(message);
};

export const checkContrastRatio = (
  foreground: string,
  background: string
): boolean => {
  // Implement WCAG contrast ratio checking
  return true; // Simplified
};
```

---

## 3. n8n Configuration

⚠️ **CRITICAL SECURITY REQUIREMENTS**

Before proceeding, review the security requirements in `.github/copilot-instructions.md`:
- **Webhook Authentication**: Never deploy without API key validation
- **n8n Basic Auth**: Required for production deployments
- **HTTPS Configuration**: Use reverse proxy (nginx) with SSL/TLS
- **Environment Variables**: Validate all required vars before starting

See [Production Deployment Guide](#production-security-checklist) below for complete requirements.

### Step 1: Install and Start n8n

**Development Environment (Local Testing Only):**
```bash
# Option 1: Global installation (development only)
npm install -g n8n
n8n start

# Option 3: npx (no installation, development only)
npx n8n
```

**Production Environment (Secure Configuration):**
```bash
# Option 2: Docker with security enabled (REQUIRED for production)
docker run -d \
  --name n8n-production \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD="$(openssl rand -base64 32)" \
  -e N8N_HOST=n8n.yourdomain.com \
  -e N8N_PROTOCOL=https \
  -e WEBHOOK_URL=https://n8n.yourdomain.com/ \
  -e PROJECT_ROOT=/data/projects/heirloom-mobile \
  -v ~/.n8n:/home/node/.n8n \
  -v $(pwd):/home/node/project \
  n8nio/n8n

# ⚠️ IMPORTANT: Deploy behind nginx reverse proxy with SSL (see Production Deployment Guide)
```

Access n8n: 
- Development: http://localhost:5678
- Production: https://n8n.yourdomain.com (with basic auth)

### Step 2: Configure Credentials

In n8n UI:

1. **Anthropic API**
   - Go to: Settings → Credentials → Add New
   - Type: HTTP Header Auth
   - Name: `anthropicApi`
   - Header Name: `x-api-key`
   - Header Value: Your Anthropic API key

2. **GitHub API**
   - Go to: Settings → Credentials → Add New
   - Type: GitHub API
   - Name: `githubCredentials`
   - Access Token: Your GitHub Personal Access Token

3. **File System Access**

- n8n does not provide a "File System" option in the UI. To allow n8n to read/write binary files outside its default data directory you must either set an environment variable (when running n8n directly) or mount a host directory into the container and point n8n to the container path.

- Important: paths that contain spaces must be quoted or escaped in shell commands. Examples below use generic placeholders (no user-specific paths).

Examples (host shell)

```bash
# Quoted (recommended if the path contains spaces)
export N8N_DEFAULT_BINARY_DATA_DIRECTORY="/path/to/HeirloomMobile"

# Escaped-space alternative
export N8N_DEFAULT_BINARY_DATA_DIRECTORY=/path/to/HeirloomMobile\ with\ spaces

# Better: create a space-free symlink and use that instead
mkdir -p "$HOME/Projects"
ln -s "/path/to/HeirloomMobile" "$HOME/Projects/HeirloomMobile"
export N8N_DEFAULT_BINARY_DATA_DIRECTORY="$HOME/Projects/HeirloomMobile"
```

Docker example (quote the host path in `-v` and use a container path without spaces):

```bash
docker run -d \
  --name n8n-production \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD="$(openssl rand -base64 32)" \
  -e N8N_HOST=n8n.yourdomain.com \
  -e N8N_PROTOCOL=https \
  -e WEBHOOK_URL=https://n8n.yourdomain.com/ \
  -e PROJECT_ROOT=/data/projects/heirloom-mobile \
  -e N8N_DEFAULT_BINARY_DATA_DIRECTORY=/data/projects/heirloom-mobile \
  -v "/path/to/HeirloomMobile":/data/projects/heirloom-mobile \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

Notes:

- When running n8n in Docker the environment variable value should point to the path inside the container (no spaces).
- If you use a `.env` file, some dotenv parsers will include quotes in the value; test and validate the resulting value in your runtime.
- Use the "Read Binary File" and "Write Binary File" nodes in workflows and specify absolute paths appropriate for your runtime (host paths when running natively, container paths when running in Docker).

Helper script

We include a small helper script to create a space-free symlink and print the correct export/Docker examples:

`scripts/setup-n8n-data-dir.sh`

Usage examples:

```sh
# Interactive (prompts for path)
./scripts/setup-n8n-data-dir.sh

# Non-interactive
./scripts/setup-n8n-data-dir.sh /path/to/HeirloomMobile

# Overwrite an existing symlink without prompting
./scripts/setup-n8n-data-dir.sh --force /path/to/HeirloomMobile
```

The script is idempotent: if the symlink already points to the target it does nothing. The `--force` (or `-f`) flag removes an existing symlink that points to a different location and replaces it without prompting.

### Step 3: Environment Variables

Create `.env` file in n8n directory:

```bash
# n8n Configuration
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http
WEBHOOK_URL=http://localhost:5678

# GitHub
GITHUB_OWNER=your-username
GITHUB_REPO=heirloom-mobile

# Anthropic
ANTHROPIC_API_KEY=your-api-key

# Project Paths
PROJECT_ROOT=/path/to/HeirloomMobile
```

### Step 4: Import Workflows

```bash
# In n8n UI:
# 1. Click "Import from File"
# 2. Select each workflow JSON file:

# Import these workflows:
- 01-project-manager-agent.json
- 02-ui-generator-agent.json
- 03-code-review-agent.json
```

---

## 4. Agent Workflows

### Workflow 1: Project Manager Agent

**Purpose**: Orchestrates development tasks
**Trigger**: Webhook POST to `/webhook/project-manager`
**Input**:
```json
{
  "requirements": "Create Recording Screen with real-time transcription",
  "github_owner": "your-username",
  "github_repo": "heirloom-mobile"
}
```

**Test**:
```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create a Recording Screen component with start/stop recording, real-time transcription display, and audio level indicator",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

### Workflow 2: UI Generator Agent

**Purpose**: Generates React Native components
**Trigger**: Webhook POST to `/webhook/ui-generator-agent`
**Input**:
```json
{
  "task": {
    "name": "RecordingScreen",
    "description": "Screen for audio recording with STT",
    "assigned_agent": "UI"
  },
  "issue_number": 1,
  "github_owner": "your-username",
  "github_repo": "heirloom-mobile"
}
```

### Workflow 3: Code Review Agent

**Purpose**: Automated PR code review
**Trigger**: GitHub webhook (PR opened)
**Setup**:
1. In GitHub repo: Settings → Webhooks → Add webhook
2. Payload URL: `http://your-server:5678/webhook/code-review-webhook`
3. Content type: `application/json`
4. Events: `Pull requests`

---

## 5. Project Structure

```
HeirloomMobile/
├── src/
│   ├── components/          # Reusable UI components
│   │   ├── RecordButton.tsx
│   │   ├── AudioPlayer.tsx
│   │   └── __tests__/
│   ├── screens/             # Screen components
│   │   ├── RecordingScreen.tsx
│   │   ├── ReviewScreen.tsx
│   │   └── __tests__/
│   ├── navigation/          # Navigation configuration
│   │   └── AppNavigator.tsx
│   ├── services/            # API and external services
│   │   ├── api.ts
│   │   ├── audio.ts
│   │   ├── stt.ts
│   │   └── tts.ts
│   ├── store/               # Redux store
│   │   ├── index.ts
│   │   ├── recordingSlice.ts
│   │   └── storiesSlice.ts
│   ├── utils/               # Utility functions
│   │   ├── accessibility.ts
│   │   └── rtl.ts
│   ├── types/               # TypeScript types
│   │   └── index.ts
│   └── styles/              # Theme and styles
│       └── theme.ts
├── android/
├── ios/
├── __tests__/
├── .env
├── package.json
└── tsconfig.json
```

---

## 6. Running the System

### Development Workflow

1. **Start n8n**
```bash
n8n start
# Or with Docker:
docker start n8n
```

2. **Activate Workflows**
In n8n UI:
- Activate "Heirloom Project Manager Agent"
- Activate "Heirloom UI Generator Agent"
- Activate "Heirloom Code Review Agent"

3. **Create Development Task**
```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Phase 1: Create Authentication screens with Firebase integration",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

4. **Monitor Progress**
- n8n UI: http://localhost:5678/workflows
- GitHub: Check issues and PRs
- Project: Pull and test generated code

### Agent Workflow

```
1. You send requirements to Project Manager Agent
   ↓
2. Agent breaks down into tasks and creates GitHub issues
   ↓
3. Agent triggers specialized agents (UI, Backend Integration, etc.)
   ↓
4. Specialized agents generate code and create PRs
   ↓
5. Code Review Agent automatically reviews PRs
   ↓
6. You review and merge (or request changes)
   ↓
7. Testing Agent runs tests on merged code
   ↓
8. Documentation Agent generates docs
```

---

## 7. Monitoring & Debugging

### n8n Execution Monitoring

```bash
# View execution logs in n8n UI
http://localhost:5678/executions

# Export execution data
curl http://localhost:5678/rest/executions/EXECUTION_ID
```

### Debugging Failed Workflows

1. **Check Execution Log**
   - n8n UI → Executions → Click failed execution
   - Review error message and stack trace

2. **Manual Testing**
   ```bash
   # Test individual nodes
   # In n8n UI: Click "Test workflow" button
   ```

3. **Validate Generated Code**
   ```bash
   cd /path/to/HeirloomMobile
   
   # TypeScript check
   npx tsc --noEmit
   
   # Run tests
   npm test
   
   # Lint
   npm run lint
   ```

### Common Issues

**Issue: Claude API Rate Limit**
```
Solution: Add rate limiting in workflows
- Add "Wait" node between API calls
- Set delay to 1-2 seconds
```

**Issue: GitHub API Rate Limit**
```
Solution: Use authenticated requests
- Ensure GitHub credentials are configured
- Authenticated: 5000 requests/hour
- Unauthenticated: 60 requests/hour
```

**Issue: File Write Permissions**
```
Solution: Check n8n file system access
- Settings → File System → Add allowed directory
- Or run n8n with proper permissions
```

---

## 8. Cost Management

### Estimated Costs (Monthly)

**Claude API (Sonnet 4)**
- Cost per component generation: ~$0.10-0.30
- 50 components/month: ~$5-15
- Code reviews: ~$0.05 per review
- 100 reviews/month: ~$5

**Total estimated: $10-20/month**

### Cost Optimization

1. **Cache LLM Responses**
```javascript
// Add caching node before Claude API calls
// Store common responses in n8n database
```

2. **Use Smaller Models for Simple Tasks**
```javascript
// For simple tasks, use Claude Haiku (cheaper)
{
  "model": "claude-3-haiku-20240307",  // $0.25 per MTok
  "max_tokens": 1000
}
```

3. **Batch Operations**
```javascript
// Process multiple small tasks in one API call
// Instead of 10 separate calls, batch into 1-2 calls
```

4. **Rate Limiting**
```javascript
// Add delays between executions
// Prevent unnecessary duplicate runs
```

---

## 9. Next Steps

### Immediate Actions (Week 1)

- [ ] Install and configure n8n
- [ ] Import all workflow JSON files
- [ ] Configure credentials (Claude, GitHub)
- [ ] Create GitHub repository
- [ ] Test Project Manager Agent with simple task
- [ ] Review and merge first generated PR

### Week 2-3: Full System Testing

- [ ] Generate authentication screens
- [ ] Generate recording components
- [ ] Test code review automation
- [ ] Refine agent prompts based on output quality
- [ ] Set up monitoring dashboards

### Week 4+: Scale and Optimize

- [ ] Create additional specialized agents:
  - Backend Integration Agent
  - State Management Agent
  - Testing Agent
  - Documentation Agent
- [ ] Implement continuous improvement loop
- [ ] Add performance monitoring
- [ ] Optimize costs

---

## 10. Advanced Configuration

### Creating Custom Agents

Template for new agent:

```json
{
  "name": "Custom Agent Name",
  "nodes": [
    {
      "name": "Webhook Trigger",
      "type": "n8n-nodes-base.webhook",
      "parameters": {
        "path": "custom-agent-webhook"
      }
    },
    {
      "name": "Claude AI",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "url": "https://api.anthropic.com/v1/messages",
        "method": "POST",
        "body": {
          "model": "claude-sonnet-4-20250514",
          "messages": [
            {
              "role": "user",
              "content": "Your custom prompt here"
            }
          ]
        }
      }
    }
  ]
}
```

### Integration with CI/CD

```yaml
# .github/workflows/agent-integration.yml
name: n8n Agent Integration

on:
  push:
    branches: [ main ]

jobs:
  trigger-agents:
    runs-on: ubuntu-latest
    steps:
      - name: Trigger Documentation Agent
        run: |
          curl -X POST ${{ secrets.N8N_WEBHOOK_URL }}/documentation-agent \
            -H "Content-Type: application/json" \
            -d '{"commit_sha": "${{ github.sha }}"}'
```

---

## Troubleshooting

### Q: Workflows not triggering?
A: Check webhook URLs, ensure workflows are activated, verify n8n is running

### Q: Code quality not good enough?
A: Refine system prompts in Claude API nodes, add more context/examples

### Q: PRs created but tests fail?
A: Ensure Test Agent has access to run `npm test`, check Node.js version

### Q: Too expensive?
A: Switch to Claude Haiku for simple tasks, implement caching, batch requests

---

## Production Security Checklist

⚠️ **BEFORE deploying to production, complete ALL these steps:**

### Environment Validation

Run the validation script (see `scripts/validate-env.sh`):
```bash
./scripts/validate-env.sh
```

Required environment variables:
- `N8N_BASIC_AUTH_ACTIVE=true`
- `N8N_BASIC_AUTH_USER` (strong username)
- `N8N_BASIC_AUTH_PASSWORD` (minimum 32 characters)
- `DEPLOYMENT_API_KEYS` (comma-separated API keys for webhook auth)
- `PROJECT_ROOT` (absolute path to project)
- `ANTHROPIC_API_KEY` (valid API key)
- `GITHUB_TOKEN` (fine-grained token with minimal permissions)

### Security Hardening

- [ ] Enable n8n basic authentication
- [ ] Configure webhook API key validation in ALL workflows
- [ ] Set up HTTPS with valid SSL certificate (Let's Encrypt)
- [ ] Deploy n8n behind nginx reverse proxy
- [ ] Configure firewall rules (allow only HTTPS)
- [ ] Enable n8n rate limiting
- [ ] Review GitHub token permissions (use fine-grained tokens)
- [ ] Set up IP whitelisting (optional but recommended)

### Infrastructure Setup

- [ ] Configure SSL/TLS certificates
- [ ] Set up log rotation (`~/.n8n/logs/`)
- [ ] Configure database backups (see `scripts/backup-n8n.sh`)
- [ ] Set up monitoring and alerting
- [ ] Test disaster recovery procedures

### Testing

- [ ] Test all workflows with production credentials
- [ ] Verify webhook authentication blocks unauthorized requests
- [ ] Test error handling and fallback mechanisms
- [ ] Validate GitHub integration (create test issues/PRs)
- [ ] Test Claude API connectivity and rate limits

### Complete Guide

For complete production deployment instructions, see:
- **Production Deployment**: `.github/copilot-instructions.md` (Production Deployment Guide section)
- **Security Requirements**: `.github/copilot-instructions.md` (Security Best Practices section)
- **Monitoring Setup**: `.github/copilot-instructions.md` (Monitoring and Cost Tracking section)
- **Disaster Recovery**: `.github/copilot-instructions.md` (Disaster Recovery Procedures section)

---

## Support & Resources

### Documentation
- **This Repository**:
  - `README.md` - Project overview and quick start
  - `QUICKSTART.md` - 30-minute getting started guide
  - `SETUP_GUIDE.md` - This comprehensive setup guide
  - `.github/copilot-instructions.md` - Complete security and production deployment guide
  - `ARCHITECTURE.md` - System architecture and agent flow diagrams
  - `DESIGN.md` - Agent implementation guide
  - `CONTRIBUTING.md` - Documentation standards

### External Resources
- n8n Documentation: https://docs.n8n.io
- Anthropic API Docs: https://docs.anthropic.com
- React Native Docs: https://reactnative.dev
- GitHub API Docs: https://docs.github.com/rest

### Automation Scripts
- `scripts/validate-env.sh` - Validate environment variables
- `scripts/backup-n8n.sh` - Backup n8n database and workflows
- `scripts/restore-n8n.sh` - Restore from backup

---

## ⚠️ Security Warning

**DO NOT use this setup in production without completing the Production Security Checklist above.**

Development setup (without authentication) is ONLY for local testing. Anyone with your webhook URL can trigger workflows and generate code.

---

**Ready to start building!** 🚀

**Development (Local Testing):**
```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create the complete authentication flow with Firebase",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Production (Authenticated):**
```bash
curl -X POST https://n8n.yourdomain.com/webhook/project-manager \
  -H "Content-Type: application/json" \
  -H "x-api-key: your-production-api-key" \
  -d '{
    "requirements": "Create the complete authentication flow with Firebase",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```
