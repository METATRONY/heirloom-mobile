# Heirloom n8n Agent System - Quick Start Guide

## 🚀 Get Started in 30 Minutes

### Prerequisites Check
```bash
# Verify installations
node --version    # Need 18+
npm --version
git --version
```

### Step 1: Install n8n (2 minutes)

⚠️ **SECURITY WARNING**: This quick start is for **local development only**. For production deployment, see:
- **Complete Security Guide**: `.github/copilot-instructions.md`
- **Production Setup**: `SETUP_GUIDE.md` (Production Security Checklist section)

```bash
# Quick install (development only)
npm install -g n8n

# Start n8n (no authentication - LOCAL ONLY)
n8n start

# Access at: http://localhost:5678
```

### Step 2: Create React Native Project (3 minutes)
```bash
# Create project
npx react-native init HeirloomMobile --template react-native-template-typescript
cd HeirloomMobile

# Create GitHub repo
git init
git add .
git commit -m "Initial commit"
gh repo create heirloom-mobile --public --source=. --push
```

### Step 3: Configure n8n (5 minutes)

1. **Open n8n**: http://localhost:5678
2. **Add Credentials**:
   - Settings → Credentials → Add New
   - **Anthropic API**: 
     - Type: HTTP Header Auth
     - Name: `anthropicApi`
     - Header: `x-api-key`
     - Value: `YOUR_ANTHROPIC_KEY`
   - **GitHub API**:
     - Type: GitHub API
     - Name: `githubCredentials`
     - Token: `YOUR_GITHUB_TOKEN`

3. **Set File System Access**:
   - Settings → File System
   - Add: `/absolute/path/to/HeirloomMobile`

### Step 4: Import Workflows (5 minutes)

Download workflows:
```bash
# Create workflows directory
mkdir n8n-workflows
cd n8n-workflows

# Download workflow files (from the created files)
# Or manually import in n8n UI
```

In n8n UI:
1. Click "+" → "Import from File"
2. Import each workflow JSON:
   - 01-project-manager-agent.json
   - 02-ui-generator-agent.json
   - 03-code-review-agent.json
   - 04-backend-integration-agent.json

3. **Activate** each workflow (toggle switch)

### Step 5: Configure Project Paths (2 minutes)

Edit each workflow and update:
```javascript
// Change these paths in ALL workflows:
"/path/to/HeirloomMobile" → "/Users/yourname/HeirloomMobile"
"/path/to/heirloom-backend" → "/Users/yourname/heirloom-backend"
"your-username" → "your-github-username"
"heirloom-mobile" → "your-repo-name"
```

### Step 6: Test the System (10 minutes)

**Test 1: Project Manager Agent**
```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create a simple Hello World screen component with a button that shows an alert",
    "github_owner": "your-github-username",
    "github_repo": "heirloom-mobile"
  }'
```

Expected: 
- ✅ Task created in GitHub Issues
- ✅ UI Generator Agent triggered
- ✅ Component created
- ✅ Pull Request opened

**Test 2: UI Generator Agent (Direct)**
```bash
curl -X POST http://localhost:5678/webhook/ui-generator-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "name": "WelcomeScreen",
      "description": "Create a welcome screen with a greeting message and a Start button",
      "assigned_agent": "UI"
    },
    "issue_number": 1,
    "github_owner": "your-github-username",
    "github_repo": "heirloom-mobile"
  }'
```

Expected:
- ✅ Component file created
- ✅ Test file created
- ✅ Tests run and pass
- ✅ PR created with code

### Step 7: Review Generated Code (5 minutes)

1. Go to GitHub: https://github.com/your-username/heirloom-mobile/pulls
2. Review the PR created by the agent
3. Check the generated code
4. Merge if good, or comment for changes

---

## 📋 Common Commands

### Trigger Full Development Cycle
```bash
# Create authentication flow
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create complete authentication flow with:\n1. Login screen (email + password)\n2. Sign up screen\n3. Forgot password screen\n4. Firebase integration\n5. Form validation\n6. Loading states",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

### Generate Specific Component
```bash
# Recording screen
curl -X POST http://localhost:5678/webhook/ui-generator-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "name": "RecordingScreen",
      "description": "Audio recording screen with:\n- Start/Stop button\n- Recording timer\n- Real-time transcription display\n- Audio level indicator\n- Pause/Resume functionality",
      "assigned_agent": "UI"
    },
    "issue_number": 2,
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

### Generate API Service
```bash
# Audio upload service
curl -X POST http://localhost:5678/webhook/backend-integration-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "name": "Audio Upload Service",
      "description": "Create service for uploading audio files to backend:\n- Multipart form upload\n- Progress tracking\n- Retry on failure\n- Offline queue\n- Compression before upload",
      "assigned_agent": "Backend Integration"
    },
    "issue_number": 3,
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

---

## 🎯 Development Workflow

### Daily Workflow

**Morning: Plan Tasks**
```bash
# Send requirements to Project Manager
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Today tasks:\n1. Story browser screen\n2. Story detail view\n3. Edit story functionality",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Throughout Day: Review PRs**
- Agents create PRs automatically
- Code Review Agent adds comments
- You review and merge

**End of Day: Check Progress**
```bash
# Check n8n executions
open http://localhost:5678/executions

# Check GitHub
gh pr list
```

### Weekly Workflow

**Monday**: Plan week's features with Project Manager Agent
**Tue-Thu**: Review and merge PRs, test generated code
**Friday**: Integration testing, bug fixes, documentation

---

## 🔧 Troubleshooting

### Issue: n8n won't start
```bash
# Check port
lsof -i :5678

# Kill process if needed
kill -9 $(lsof -t -i :5678)

# Restart
n8n start
```

### Issue: Workflow fails with "file not found"
```bash
# Check paths in workflow
# Make sure absolute paths are correct
# Example: /Users/yourname/HeirloomMobile not ~/HeirloomMobile
```

### Issue: Claude API errors
```bash
# Check API key in n8n credentials
# Verify you have credits: https://console.anthropic.com/settings/billing

# Test API key
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: YOUR_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":1024,"messages":[{"role":"user","content":"Hello"}]}'
```

### Issue: GitHub API rate limit
```bash
# Check rate limit
gh api rate_limit

# Wait or use authenticated requests (should be automatic with credentials)
```

### Issue: Generated code has errors
```bash
# Review the code in PR
# Add comments with requested changes
# Agent will see comments and generate fixes

# Or trigger regeneration:
curl -X POST http://localhost:5678/webhook/ui-generator-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "name": "RecordingScreen - Fixed",
      "description": "Fix the previous RecordingScreen with these changes:\n- Add proper error handling\n- Fix TypeScript errors\n- Add accessibility labels"
    },
    "issue_number": 5,
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

---

## 📊 Monitor & Optimize

### View Execution History
```bash
# In n8n UI
http://localhost:5678/executions

# Filter by workflow
# Check execution time
# View error logs
```

### Cost Tracking
```bash
# Check Anthropic usage
# https://console.anthropic.com/settings/usage

# Typical costs:
# - Component generation: $0.10-0.30
# - Code review: $0.05
# - Documentation: $0.02
```

### Performance Tips
1. **Batch similar tasks** - Generate multiple screens in one request
2. **Cache common responses** - Reuse generated utilities
3. **Use smaller models** - Switch to Haiku for simple tasks
4. **Rate limiting** - Add delays between API calls

---

## 🎉 Success Checklist

- [ ] n8n running on http://localhost:5678
- [ ] All 4 workflows imported and activated
- [ ] Credentials configured (Anthropic, GitHub)
- [ ] Test workflow executed successfully
- [ ] First PR created by agent
- [ ] Code Review Agent commented on PR
- [ ] Code merged and running in React Native app

---

## 📚 Next Steps

### Phase 1 (Week 1)
- [ ] Generate authentication screens
- [ ] Test all generated components
- [ ] Refine agent prompts based on output

### Phase 2 (Week 2-3)
- [ ] Generate recording functionality
- [ ] Create review/edit screens
- [ ] Implement backend integration

### Phase 3 (Week 4+)
- [ ] Add testing agent
- [ ] Add documentation agent
- [ ] Optimize and scale

---

## 🆘 Support

- **n8n Docs**: https://docs.n8n.io
- **Claude API**: https://docs.anthropic.com
- **React Native**: https://reactnative.dev
- **Community**: n8n Discord, Reddit r/n8n

---

## 💡 Pro Tips

1. **Start Small**: Test with simple components first
2. **Iterate**: Refine prompts based on output quality
3. **Review Everything**: Always review generated code before merging
4. **Keep Context**: Maintain style guides and examples for agents
5. **Monitor Costs**: Track API usage regularly
6. **Document Learnings**: Note what prompts work best
7. **Security First**: Never deploy without authentication (see Production Security Checklist)

---

## 🔗 Next Steps

### Learn More
- **Complete Setup**: See `SETUP_GUIDE.md` for comprehensive configuration
- **Security Guide**: See `.github/copilot-instructions.md` for production deployment
- **Architecture**: See `ARCHITECTURE.md` for system design and agent flows
- **Contributing**: See `CONTRIBUTING.md` for documentation standards

### Production Deployment
⚠️ **Before deploying to production:**
1. Complete the Production Security Checklist in `SETUP_GUIDE.md`
2. Enable webhook authentication (API keys)
3. Enable n8n basic authentication
4. Set up HTTPS with reverse proxy
5. Run environment validation: `./scripts/validate-env.sh`
6. Set up backups: `./scripts/backup-n8n.sh`

---

## ⚠️ Security Reminder

**This quick start is for LOCAL DEVELOPMENT ONLY.** 

Do NOT use this configuration in production without:
- Enabling webhook authentication
- Enabling n8n basic auth
- Setting up HTTPS
- Configuring fine-grained GitHub tokens

See `SETUP_GUIDE.md` and `.github/copilot-instructions.md` for complete security requirements.

---

**You're ready to build! 🚀**

Start with:
```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create a simple Hello World screen",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```
