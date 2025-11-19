# AI Mobile Agents - Automated Development with n8n + Claude

> Build ANY React Native mobile app using AI agents orchestrated by n8n workflows

## ⚡ Quick Customization (15 minutes)

**This system works for ANY mobile app!** Here's how to customize it for your project:

```bash
# 1. Copy configuration template
cp config/app-config.example.json config/app-config.json

# 2. Edit config/app-config.json with your app details
#    - App name & GitHub repo
#    - Target languages
#    - Accessibility requirements
#    - Tech stack preferences

# 3. Validate configuration
npm run validate

# 4. Apply configuration to all agents
npm run configure

# 5. Import agents to n8n and start building!
```

**📖 Full Guide:** [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md)

**🎨 Examples:** [Heirloom](examples/heirloom/) (elderly users, Hebrew+English) | [E-Commerce](examples/ecommerce/) | [Fitness App](examples/fitness/)

**💡 Reusability:** 75-80% of the system is generic. Only prompts and examples are app-specific.

---

## 🎯 What This Is

An **automated development system** that uses AI agents (powered by Claude) to generate, review, test, and document your Heirloom mobile app code. Instead of writing every component manually, you describe what you need, and specialized AI agents create production-ready code.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                  YOU (Developer)                    │
│          Describe features in plain English          │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│              n8n Orchestration Platform             │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │   Project    │  │     Code     │  │  Review  │ │
│  │   Manager    │  │   Generator  │  │  Agent   │ │
│  │   Agent      │  │   Agents     │  │          │ │
│  └──────────────┘  └──────────────┘  └──────────┘ │
│                                                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │
│  │   Testing    │  │     Docs     │  │  Deploy  │ │
│  │   Agent      │  │   Agent      │  │  Agent   │ │
│  └──────────────┘  └──────────────┘  └──────────┘ │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────┐
│              Generated Deliverables                 │
│                                                     │
│  • React Native Components (TypeScript)             │
│  • Unit Tests (Jest)                                │
│  • API Integration Services                         │
│  • Documentation (Markdown)                         │
│  • Pull Requests (GitHub)                           │
└─────────────────────────────────────────────────────┘
```

## ✨ Key Features

### 1. **Project Manager Agent**
- Breaks down high-level requirements into specific tasks
- Creates GitHub issues automatically
- Orchestrates specialized agents
- Tracks progress and dependencies

### 2. **UI Generator Agent**
- Creates React Native components (TypeScript)
- Ensures accessibility (WCAG 2.1)
- Implements RTL/LTR support (Hebrew/English)
- Follows Heirloom style guide
- Generates unit tests
- Creates pull requests

### 3. **Backend Integration Agent**
- Generates API service modules
- Implements error handling and retry logic
- Creates TypeScript types
- Handles offline queueing
- Includes comprehensive tests

### 4. **Code Review Agent**
- Automatically reviews all PRs
- Checks for accessibility issues
- Validates TypeScript types
- Ensures security best practices
- Posts inline comments
- Approves or requests changes

### 5. **System Design Agent** ✨ NEW
- Generates complete system architecture
- Creates database schemas and API designs
- Plans 3-phase scalability (0-10K, 10K-50K, 50K-100K users)
- Validates budget constraints
- Includes security considerations
- Auto-creates implementation GitHub issues

### 6. **Security Agent** 🔒
- Automated security audits (daily + on-demand)
- **Input validation** to prevent injection attacks
- Dependency vulnerability scanning (npm audit + Snyk)
- Code security analysis (ESLint security plugin)
- **Enhanced secret detection** (AWS keys, GitHub tokens, private keys, API keys)
- **License Compliance Scanning** 📜 **NEW - CORE**: Detects GPL conflicts, commercial restrictions, tracks all open source licenses
- **API Penetration Testing** 🛡️ **NEW - CORE**: Automated tests for SQL injection, XSS, auth bypass, IDOR, rate limiting
- OWASP Top 10 & Mobile Top 10 compliance
- **Safe dry-run analysis** of available fixes (no automatic breaking changes)
- Generates comprehensive security + license + pen test reports
- Creates PRs with security findings (manual review required)

### 7. **Testing Agent** ✅
- Analyzes code structure and generates comprehensive tests
- Supports unit, E2E, and accessibility testing
- Uses Jest and React Testing Library
- Validates test coverage (targets 90%+)
- Identifies edge cases and error scenarios
- Creates PR with test files and coverage reports

### 8. **Documentation Agent** (Coming Soon)
- Creates API documentation
- Generates usage guides
- Updates README files
- Maintains changelog

### 7. **Deploy Agent** ⚠️ (DEMO/Prototype)
- **Status:** Demonstration workflow (NOT production-ready)
- Automates app store deployments (iOS & Android)
- AI-generated release notes via Claude
- Platform routing (iOS, Android, or both)
- **⚠️ IMPORTANT:** Builds and uploads are SIMULATED for safety
- **See:** `PRODUCTION_REQUIREMENTS.md` for production implementation
- **Authentication:** API key required (configure via environment variable)

**Current Features:**
- ✅ Input validation and sanitization
- ✅ API key authentication
- ✅ Claude AI release notes generation  
- ✅ Platform routing (iOS/Android/both)
- ✅ Deployment report generation
- ⚠️ Simulated builds (no actual Fastlane/Gradle execution)
- ⚠️ Simulated uploads (no actual app store uploads)
- ⚠️ Simulated git tags (not actually created)

**Production Requirements:**
- Real build execution (Fastlane for iOS, Gradle for Android)
- Real app store uploads (TestFlight, Google Play)
- Real pre-flight checks (tests, version verification)
- Real git operations (tag creation and push)
- Monitoring and alerting system
- Rollback mechanism

**Files:**
- `10-deploy-agent.json` - n8n workflow (19 nodes)
- `DEPLOY_AGENT_README.md` - Implementation guide
- `PRODUCTION_REQUIREMENTS.md` - Production checklist

## 🚀 Quick Start

### Prerequisites
```bash
node --version  # 18+
npm --version
git --version
```

### 5-Minute Setup (Development Only)

⚠️ **SECURITY WARNING**: This quick setup is for **local development only**. For production, see [Security & Production Deployment](#-security--production-deployment) below.

```bash
# 1. Install n8n
npm install -g n8n

# 2. Start n8n (NO AUTHENTICATION - LOCAL ONLY)
n8n start  # Access at http://localhost:5678

# 3. Create React Native project
npx react-native init HeirloomMobile --template react-native-template-typescript

# 4. Import workflows (see QUICKSTART.md)

# 5. Configure credentials in n8n UI
#    - Anthropic API key
#    - GitHub token (use fine-grained with minimal permissions)

# 6. Activate workflows

# 7. Start building!
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create login screen with email and password",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**⚠️ DO NOT deploy this configuration to production** - see Security & Production Deployment section below.

## 📁 What's Included

```
heirloom-n8n-workflows/
├── README.md                              # This file
├── QUICKSTART.md                          # 30-min setup guide
├── SETUP_GUIDE.md                         # Comprehensive setup
├── TESTING_AGENT_USAGE.md                 # Testing Agent guide
├── 01-project-manager-agent.json          # Orchestration workflow
├── 02-ui-generator-agent.json             # Component generator
├── 03-code-review-agent.json              # Automated reviews
├── 04-backend-integration-agent.json      # API services generator
└── 06-security-agent.json                 # Security audit & vulnerability scanning
├── 05-system-design-agent.json            # System architecture designer ✨ NEW
├── SYSTEM_DESIGN_AGENT_USAGE.md           # System Design Agent guide
└── test-system-design-input.json          # Sample input for testing
└── 07-testing-agent.json                  # Test generation workflow
```

## 🎮 Usage Examples

### Generate a Complete Feature
```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Recording feature with:
    - Audio recording screen
    - Real-time transcription display
    - Pause/resume controls
    - Upload to Firebase Storage
    - Progress indicator",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Result:**
- 5 GitHub issues created (one per component)
- 5 agents triggered in parallel
- 5 PRs created with generated code
- All code reviewed automatically
- Tests run and documented

### Generate a Single Component
```bash
curl -X POST http://localhost:5678/webhook/ui-generator-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "name": "StoryCard",
      "description": "Card component showing story title, date, duration, with play button",
      "assigned_agent": "UI"
    },
    "issue_number": 10,
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Result:**
- `StoryCard.tsx` component created
- `StoryCard.test.tsx` tests created
- All accessibility features included
- PR opened for review

### Generate API Integration
```bash
curl -X POST http://localhost:5678/webhook/backend-integration-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": {
      "name": "Stories API Service",
      "description": "Service for fetching, creating, updating stories"
    },
    "issue_number": 11,
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Result:**
- API service module created
- TypeScript types defined
- Error handling implemented
- Offline queue added
- Tests included

### Run Security Audit
```bash
curl -X POST http://localhost:5678/webhook/security-agent \
  -H "Content-Type: application/json" \
  -d '{
    "task": "security_audit",
    "scope": "full",
    "project_path": "/path/to/heirloom-mobile",
### Generate Tests for Existing Code
```bash
curl -X POST http://localhost:5678/webhook/testing-agent \
  -H "Content-Type: application/json" \
  -d '{
    "target": "src/components/StoryCard.tsx",
    "test_types": ["unit", "accessibility"],
    "issue_number": 12,
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Result:**
- npm audit scan completed
- Snyk vulnerability scan completed
- ESLint security analysis completed
- Hardcoded secrets detected
- **License compliance report generated** 📜 **NEW**: GPL conflicts, commercial restrictions, unknown licenses
- **Penetration testing completed** 🛡️ **NEW**: SQL injection, XSS, auth bypass, IDOR, rate limiting tests
- Comprehensive SECURITY_AUDIT.md + LICENSE_REPORT.md + PENTEST_REPORT.md generated
- Vulnerable dependencies automatically updated
- PR created with security + license + pen test findings
- OWASP Top 10 & Mobile Top 10 compliance checked
- Comprehensive test suite generated
- Unit tests for all functions/methods
- Accessibility tests included
- Edge cases and error scenarios covered
- 90%+ code coverage achieved
- PR opened with coverage report

## 💰 Cost Breakdown

### Claude API (Sonnet 4)
- **Component Generation**: $0.10-0.30 per component
- **Code Review**: $0.05 per PR
- **Documentation**: $0.02 per doc

### Example Monthly Cost
- 50 components: $5-15
- 100 code reviews: $5
- 50 docs: $1

**Total: $11-21/month** for active development

Compare to hiring a developer:
- Junior dev: $3,000-5,000/month
- Senior dev: $8,000-15,000/month
- **Savings: 99%+**

## 🎯 Benefits

### Speed
- Generate components in **2-5 minutes** vs 2-4 hours manually
- Review PRs in **30 seconds** vs 30-60 minutes manually
- **10-20x faster** development cycle

### Quality
- Consistent code style
- Always includes tests
- Accessibility built-in
- Security best practices
- RTL/LTR support automatic

### Learning
- See best practices in action
- Learn from generated code
- Improve your own skills

### Scalability
- Generate 10 components as easily as 1
- No developer burnout
- Consistent output quality

## 📊 Development Timeline

### Traditional Development (Manual)
- Phase 1 (Auth + Recording): **6-8 weeks**
- Phase 2 (Review + Edit): **4-6 weeks**
- Phase 3 (Polish + Testing): **3-4 weeks**
- **Total: 13-18 weeks**

### With AI Agents
- Phase 1: **2-3 weeks**
- Phase 2: **1-2 weeks**
- Phase 3: **1-2 weeks**
- **Total: 4-7 weeks**

**Time saved: 9-11 weeks (60-70%)**

## 🔒 Security & Production Deployment

### Development vs Production

**Development (Local Testing):**
- No authentication required
- HTTP connections acceptable
- Single-user environment
- See `QUICKSTART.md` for 30-minute setup

**Production (REQUIRED Security):**
- ⚠️ **Webhook Authentication**: API key validation mandatory
- ⚠️ **n8n Basic Auth**: Username/password required
- ⚠️ **HTTPS Only**: SSL/TLS with reverse proxy (nginx)
- ⚠️ **Fine-Grained GitHub Tokens**: Minimal permissions only
- See `.github/copilot-instructions.md` for complete guide

### Security Checklist

Before deploying to production, verify:
- [ ] Webhook API key authentication enabled
- [ ] n8n basic auth configured (`N8N_BASIC_AUTH_ACTIVE=true`)
- [ ] HTTPS configured with valid SSL certificate
- [ ] GitHub tokens use fine-grained permissions (not classic)
- [ ] All environment variables validated (`./scripts/validate-env.sh`)
- [ ] Backup strategy implemented (`./scripts/backup-n8n.sh`)
- [ ] Monitoring and alerting configured

### Quick Security Setup

```bash
# 1. Validate environment
./scripts/validate-env.sh

# 2. Deploy with Docker (secure configuration)
docker run -d \
  --name n8n-production \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD="$(openssl rand -base64 32)" \
  -e DEPLOYMENT_API_KEYS="$(openssl rand -base64 32)" \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n

# 3. Configure nginx reverse proxy (see SETUP_GUIDE.md)

# 4. Set up automated backups
./scripts/backup-n8n.sh
```

### Documentation

- **Quick Start**: `QUICKSTART.md` - 30-minute development setup
- **Complete Setup**: `SETUP_GUIDE.md` - Comprehensive configuration guide
- **Security Guide**: `.github/copilot-instructions.md` - Production deployment, monitoring, disaster recovery
- **Architecture**: `ARCHITECTURE.md` - System design and agent flows

### Privacy

- All code generated locally (not stored by AI)
- API keys secured in n8n encrypted credentials store
- GitHub tokens with minimal permissions (contents:write, pull_requests:write, issues:write)
- Code reviewed before merging
- No proprietary data sent to AI (only requirements and structure)

## 🛠️ Customization

### Modify Agent Behavior

Edit workflow JSON files to:
- Change Claude model (Sonnet, Opus, Haiku)
- Adjust system prompts
- Add custom validation
- Modify output format
- Add new agents

### Example: Make Components More Colorful
```javascript
// In 02-ui-generator-agent.json
// Modify system prompt:
"system": "You are an expert React Native developer...
           Use vibrant colors from the theme...
           Add subtle animations..."
```

### Example: Add Custom Linting
```javascript
// Add node after "Run Tests"
{
  "name": "Run ESLint",
  "type": "executeCommand",
  "command": "npm run lint"
}
```

## 🐛 Troubleshooting

See [QUICKSTART.md](./QUICKSTART.md#troubleshooting) for common issues.

### Quick Fixes

**n8n won't start**
```bash
lsof -i :5678
kill -9 $(lsof -t -i :5678)
n8n start
```

**Workflows not executing**
- Check workflows are activated (toggle in UI)
- Verify credentials are configured
- Check n8n logs: `~/.n8n/logs/`

**Generated code has errors**
- Review and comment on PR
- Add specific feedback
- Re-trigger agent with fixes

## 📚 Documentation

- **[QUICKSTART.md](./QUICKSTART.md)** - Get started in 30 minutes
- **[SETUP_GUIDE.md](./SETUP_GUIDE.md)** - Comprehensive setup and configuration
- **[n8n Documentation](https://docs.n8n.io)** - Official n8n docs
- **[Claude API](https://docs.anthropic.com)** - Anthropic API reference

## 🤝 Contributing

Want to improve the agents?

1. Modify workflow JSON files
2. Test changes locally
3. Share improvements
4. Document new patterns

## 📈 Roadmap

### ✅ Implemented Agents

- [x] **Project Manager Agent** - Orchestrates development workflow, breaks down requirements into tasks
- [x] **UI Generator Agent** - Creates React Native components with accessibility and tests
- [x] **Code Review Agent** - Automated PR reviews with quality checks
- [x] **Backend Integration Agent** - Generates API services with error handling and offline support
- [x] **Security Agent** 🔒 - Automated security audits, vulnerability scanning, and OWASP compliance checks

### 🚀 Future Agents (Coming Soon)

- [ ] **Testing Agent** (Q2 2025)
  - Automated test generation for existing code
  - Coverage analysis and gap identification
  - E2E test scenario creation
  - Visual regression testing
  - Performance benchmark tests
  - **Impact:** 90% test coverage, catch bugs before production

- [ ] **Documentation Agent** (Q2 2025)
  - Auto-generate API documentation from code
  - Create user guides and tutorials
  - Maintain changelog automatically
  - Generate inline code comments
  - Update README files based on changes
  - **Impact:** Always up-to-date docs, better onboarding

- [ ] **Deploy Agent** (Q3 2025)
  - App store submission automation (iOS/Android)
  - Build generation and optimization
  - Beta testing distribution
  - Release notes creation
  - Version management
  - **Impact:** Deploy to stores in minutes, not hours

- [x] **Performance Agent** ✅
  - Analyze code for performance bottlenecks
  - Suggest optimization strategies
  - Bundle size analysis
  - Memory leak detection
  - Render performance improvements
  - **Impact:** Faster app, better user experience

- [ ] **Refactoring Agent** (Q4 2025)
  - Identify code smells and anti-patterns
  - Suggest architectural improvements
  - Modernize legacy code
  - Extract reusable components
  - Consolidate duplicate code
  - **Impact:** Cleaner codebase, easier maintenance

- [ ] **Translation Agent** (Q4 2025)
  - Automated i18n string extraction
  - Translation file management
  - RTL/LTR layout optimization
  - Context-aware translations
  - Pluralization and formatting
  - **Impact:** Instant multi-language support (Hebrew, English, Arabic)



- [x] **System Design Agent** ✅ **COMPLETED**
  - Database schema design
  - API architecture design
  - System architecture recommendations
  - 3-phase scalability planning
  - Budget validation
  - Automatic GitHub issue creation
  - Technology stack selection
  - **Impact:** Robust, scalable architecture from day one

- [ ] **API Design Agent** (Q3 2025)
  - RESTful API endpoint design
  - GraphQL schema generation
  - API versioning strategy
  - OpenAPI/Swagger documentation
  - API security patterns
  - **Impact:** Well-designed, documented APIs

## 💡 Pro Tips

1. **Start Simple** - Test with "Hello World" first
2. **Iterate** - Refine requirements based on output
3. **Review Everything** - Always review generated code
4. **Provide Context** - More details = better results
5. **Learn Patterns** - Study what works, reuse successful prompts
6. **Batch Tasks** - Generate multiple related components together
7. **Monitor Costs** - Track API usage regularly
8. **Document Wins** - Note what prompts produce best results

## 🎓 Learning Resources

### Prompt Engineering for Code Generation
- Be specific about requirements
- Include examples when possible
- Mention edge cases
- Specify tech stack details
- Request specific patterns

### Good Requirement Examples

**Bad:**
> "Create a recording screen"

**Good:**
> "Create a RecordingScreen component with:
> - Start/stop recording button (large, high contrast)
> - Real-time transcription display (RTL support)
> - Recording timer (mm:ss format)
> - Audio level indicator (visual bars)
> - Pause/resume controls
> - Auto-save every 30 seconds
> - Offline support
> - Accessibility labels in Hebrew and English"

## 🌟 Success Stories

### Example: Authentication Flow
**Input**: "Create complete authentication flow"
**Output**: 
- 5 screens generated
- All with tests
- Firebase integrated
- Form validation
- Loading states
- Error handling
- **Time: 45 minutes** (vs 2-3 days manually)

### Example: Recording Feature
**Input**: "Build audio recording with STT"
**Output**:
- RecordingScreen component
- Audio service
- STT integration
- Local storage
- Upload queue
- Progress tracking
- **Time: 1 hour** (vs 1 week manually)

## 🆘 Support

- **Issues**: GitHub Issues
- **Questions**: GitHub Discussions
- **n8n Community**: [community.n8n.io](https://community.n8n.io)
- **Claude API**: [Anthropic Discord](https://discord.gg/anthropic)

## 📄 License

This project is for Heirloom internal development. See your organization's license.

---

## 🚀 Ready to Build?

```bash
# Clone workflows
git clone [your-repo]

# Start n8n
n8n start

# Import workflows
# Configure credentials
# Start building!

curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Your first feature here!",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

**Questions?** Check [QUICKSTART.md](./QUICKSTART.md) or [SETUP_GUIDE.md](./SETUP_GUIDE.md)

---

Built with ❤️ using [n8n](https://n8n.io) and [Claude](https://anthropic.com)
