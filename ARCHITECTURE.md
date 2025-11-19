# Heirloom n8n Agent System - Architecture & Flow Diagrams

## System Architecture

### High-Level Overview (All 13 Agents)

```
                              ┌─────────────────┐
                              │   Developer     │
                              │  (You/Ehud)     │
                              └────────┬────────┘
                                       │
                                       │ Requirements (Plain English)
                                       ▼
                       ┌───────────────────────────────┐
                       │      n8n Platform             │
                       │   (Workflow Orchestration)    │
                       └───────────┬───────────────────┘
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
                    ▼              ▼              ▼
         ┌────────────────┐ ┌──────────┐ ┌──────────────┐
         │ PHASE 1        │ │ PHASE 2  │ │ PHASE 3      │
         │ Planning &     │ │ Develop  │ │ Quality &    │
         │ Design         │ │          │ │ Deploy       │
         └────┬───────────┘ └────┬─────┘ └──────┬───────┘
              │                  │               │
    ┌─────────┴─────────┐        │      ┌────────┴────────┐
    │                   │        │      │                 │
    ▼                   ▼        ▼      ▼                 ▼
┌─────────┐      ┌─────────┐ ┌─────┐ ┌──────┐      ┌─────────┐
│System   │      │API      │ │UI   │ │Test  │      │Security │
│Design   │      │Design   │ │Gen  │ │Agent │      │Agent    │
│Agent    │      │Agent    │ │Agent│ │      │      │         │
└─────────┘      └─────────┘ └─────┘ └──────┘      └─────────┘
    │                   │        │      │                 │
    ▼                   ▼        ▼      ▼                 ▼
┌──────────────────────────────────────────────────────────┐
│           CORE DEVELOPMENT & INTEGRATION                 │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────┐ │
│  │Backend   │  │Code      │  │Docs      │  │Deploy   │ │
│  │Integrate │  │Review    │  │Agent     │  │Agent    │ │
│  └──────────┘  └──────────┘  └──────────┘  └─────────┘ │
│                                                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │Perf      │  │Refactor  │  │Translate │              │
│  │Agent     │  │Agent     │  │Agent     │              │
│  └──────────┘  └──────────┘  └──────────┘              │
│                                                          │
│  Orchestrated by: PROJECT MANAGER AGENT                 │
└────────────────────┬─────────────────────────────────────┘
                     │
        ┌────────────┴────────────┐
        │                         │
        ▼                         ▼
┌──────────────┐         ┌──────────────┐
│   GitHub     │         │   Claude AI  │
│              │         │   (Anthropic)│
│ • Issues     │◄───────►│              │
│ • PRs        │         │ • Code Gen   │
│ • Reviews    │         │ • Review     │
│ • Deployments│         │ • Analysis   │
└──────────────┘         │ • Design     │
                         │ • Security   │
                         └──────────────┘
                                 │
                                 ▼
                   ┌──────────────────────────┐
                   │   Complete Deliverables  │
                   │                          │
                   │ • System Architecture    │
                   │ • API Specifications     │
                   │ • Components & Services  │
                   │ • Comprehensive Tests    │
                   │ • Security Hardened      │
                   │ • Full Documentation     │
                   │ • Performance Optimized  │
                   │ • Multi-language Support │
                   │ • Deployed to Stores     │
                   └──────────────────────────┘
```

## Detailed Component Architecture

### 1. Project Manager Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Receive Requirements                  │
│  Input: Plain English description      │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Send to Claude AI                     │
│  "Break down into specific tasks"      │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Parse Response                        │
│  Extract: tasks, priorities, agents    │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Create GitHub Issues                  │
│  One issue per task                    │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Loop Through Tasks                    │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┬──────────┬──────────┐
      │             │          │          │
      ▼             ▼          ▼          ▼
┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐
│UI Agent │  │Backend  │  │State    │  │Test     │
│         │  │Agent    │  │Agent    │  │Agent    │
└─────────┘  └─────────┘  └─────────┘  └─────────┘
      │             │          │          │
      └──────┬──────┴──────────┴──────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Collect Results                       │
│  Track completion status               │
└────────────┬───────────────────────────┘
             │
             ▼
           DONE
```

### 2. UI Generator Agent Flow

```
START (Triggered by Project Manager or Direct)
  │
  ▼
┌────────────────────────────────────────┐
│  Receive Task Details                  │
│  - Component name                      │
│  - Requirements                        │
│  - Context                             │
└────────────┬───────────────────────────┘
             │
             ├───────────────────────────────┐
             │                               │
             ▼                               ▼
┌────────────────────────┐    ┌─────────────────────────┐
│  Load Style Guide      │    │  Load Existing          │
│  - theme.ts            │    │  Components             │
│  - accessibility.ts    │    │  - For consistency      │
└────────────┬───────────┘    └─────────┬───────────────┘
             │                          │
             └──────────┬───────────────┘
                        │
                        ▼
┌────────────────────────────────────────────────────┐
│  Send to Claude AI                                 │
│                                                    │
│  System Prompt:                                    │
│  "You are React Native expert..."                 │
│                                                    │
│  User Prompt:                                      │
│  "Create [component] with:"                        │
│  • Requirements                                    │
│  • Style guide                                     │
│  • Existing component examples                    │
└────────────┬───────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Parse Generated Code                  │
│  Extract:                              │
│  - Component code                      │
│  - Test code                           │
│  - File paths                          │
│  - Dependencies                        │
└────────────┬───────────────────────────┘
             │
             ├─────────────────────┬──────────────────┐
             │                     │                  │
             ▼                     ▼                  ▼
┌─────────────────┐   ┌─────────────────┐  ┌─────────────────┐
│Write Component  │   │Write Tests      │  │Install Deps     │
│.tsx file        │   │.test.tsx        │  │npm install      │
└────────┬────────┘   └────────┬────────┘  └────────┬────────┘
         │                     │                     │
         └─────────────────────┴─────────────────────┘
                               │
                               ▼
                   ┌─────────────────────┐
                   │  Run Tests          │
                   │  npm test           │
                   └──────────┬──────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
              Tests Pass         Tests Fail
                    │                   │
                    ▼                   ▼
         ┌────────────────┐    ┌────────────────┐
         │Create Branch   │    │Return Error    │
         │Commit Files    │    │Request Fix     │
         │Create PR       │    └────────────────┘
         └────────┬───────┘
                  │
                  ▼
         ┌────────────────────┐
         │Trigger Review Agent│
         └────────┬───────────┘
                  │
                  ▼
                DONE
```

### 3. Code Review Agent Flow

```
START (Triggered by GitHub PR webhook)
  │
  ▼
┌────────────────────────────────────────┐
│  PR Opened Event                       │
│  Webhook from GitHub                   │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Fetch PR Details                      │
│  - Title, description                  │
│  - Changed files                       │
│  - Diff                                │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Send to Claude AI for Review          │
│                                        │
│  System Prompt:                        │
│  "Senior developer code review"        │
│                                        │
│  Checklist:                            │
│  ✓ React Native best practices         │
│  ✓ Accessibility (WCAG 2.1)            │
│  ✓ RTL/LTR support                     │
│  ✓ TypeScript types                    │
│  ✓ Security                            │
│  ✓ Performance                         │
│  ✓ Error handling                      │
│  ✓ Testing                             │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Parse Review Response                 │
│  Extract:                              │
│  - Overall rating                      │
│  - Issues found                        │
│  - Positive aspects                    │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
  Approved    Request Changes
      │             │
      ▼             ▼
┌──────────┐  ┌──────────────┐
│Post      │  │Post Review   │
│Approval  │  │with Issues   │
│Comment   │  │              │
└──────────┘  └──────┬───────┘
      │              │
      │              ▼
      │        ┌──────────────┐
      │        │Loop Issues   │
      │        │              │
      │        │For Critical: │
      │        │Add Inline    │
      │        │Comments      │
      │        └──────┬───────┘
      │               │
      └───────┬───────┘
              │
              ▼
      ┌──────────────┐
      │Notify Team   │
      │Update Status │
      └──────────────┘
              │
              ▼
            DONE
```

### 4. Backend Integration Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Receive API Integration Task          │
│  - Endpoint details                    │
│  - Requirements                        │
└────────────┬───────────────────────────┘
             │
             ├─────────────────┐
             │                 │
             ▼                 ▼
┌────────────────────┐   ┌─────────────────────┐
│Load API Spec       │   │Load Existing        │
│- Endpoints         │   │API Services         │
│- Types             │   │- For patterns       │
│- Auth flow         │   └─────────┬───────────┘
└────────┬───────────┘             │
         └─────────────┬────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│  Send to Claude AI                          │
│                                             │
│  "Create API service module for:"          │
│  • Specific endpoints                       │
│  • Error handling                           │
│  • Retry logic                              │
│  • Offline queue                            │
│  • TypeScript types                         │
└────────────┬────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Parse Generated Service               │
│  Extract:                              │
│  - Service code                        │
│  - Types definitions                   │
│  - Test code                           │
│  - Dependencies                        │
└────────────┬───────────────────────────┘
             │
    ┌────────┴────────┬────────┐
    │                 │        │
    ▼                 ▼        ▼
┌────────┐    ┌────────────┐  ┌────────┐
│Write   │    │Write Types │  │Write   │
│Service │    │            │  │Tests   │
└───┬────┘    └─────┬──────┘  └───┬────┘
    │               │             │
    └───────┬───────┴─────┬───────┘
            │             │
            ▼             ▼
    ┌──────────────┐ ┌──────────────┐
    │Install Deps  │ │Run Tests     │
    └──────┬───────┘ └──────┬───────┘
           │                │
           └────────┬───────┘
                    │
           ┌────────┴────────┐
           │                 │
           ▼                 ▼
      Tests Pass      Tests Fail
           │                 │
           ▼                 ▼
    ┌──────────────┐  ┌─────────────┐
    │Generate Docs │  │Return Error │
    │              │  └─────────────┘
    └──────┬───────┘
           │
           ▼
    ┌──────────────┐
    │Create PR     │
    │with:         │
    │- Service     │
    │- Types       │
    │- Tests       │
    │- Docs        │
    └──────┬───────┘
           │
           ▼
         DONE
```

## Data Flow

### Request Flow

```
Developer
    │
    │ 1. POST requirements
    │    {
    │      "requirements": "Create login screen",
    │      "github_owner": "user",
    │      "github_repo": "repo"
    │    }
    │
    ▼
n8n Webhook
    │
    │ 2. Trigger workflow
    │
    ▼
Project Manager
    │
    │ 3. Parse & Plan
    │    - Break into tasks
    │    - Assign priorities
    │
    ▼
Task Queue
    │
    ├─────────────┬─────────────┬─────────────┐
    │             │             │             │
    ▼             ▼             ▼             ▼
GitHub Issue  GitHub Issue  GitHub Issue  GitHub Issue
    │             │             │             │
    │ 4. Create issues
    │
    ▼
Specialized Agents
    │
    │ 5. Process tasks in parallel
    │
    ├─────────────┬─────────────┬─────────────┐
    │             │             │             │
    ▼             ▼             ▼             ▼
UI Agent    Backend       State         Test
            Agent         Agent         Agent
    │             │             │             │
    │ 6. Generate code
    │
    ▼
Claude API
    │
    │ 7. AI Processing
    │
    ▼
Generated Code
    │
    │ 8. Write files
    │
    ▼
GitHub
    │
    │ 9. Create PRs
    │
    ▼
Review Agent
    │
    │ 10. Auto-review
    │
    ▼
Developer
    │
    │ 11. Final review & merge
    │
    ▼
Production Code
```

## Integration Points

### n8n ↔ Claude API

```
┌──────────────┐
│     n8n      │
│   Workflow   │
└──────┬───────┘
       │
       │ HTTP POST
       │ https://api.anthropic.com/v1/messages
       │
       │ Headers:
       │ - x-api-key: <key>
       │ - anthropic-version: 2023-06-01
       │
       │ Body:
       │ {
       │   "model": "claude-sonnet-4-20250514",
       │   "max_tokens": 8000,
       │   "messages": [...]
       │ }
       │
       ▼
┌──────────────────┐
│   Claude API     │
│   (Anthropic)    │
└──────┬───────────┘
       │
       │ Response:
       │ {
       │   "content": [{
       │     "type": "text",
       │     "text": "generated code..."
       │   }]
       │ }
       │
       ▼
┌──────────────┐
│     n8n      │
│  (Parse &    │
│   Process)   │
└──────────────┘
```

### n8n ↔ GitHub

```
┌──────────────┐
│     n8n      │
└──────┬───────┘
       │
       │ GitHub API Calls:
       │
       ├─► POST /repos/{owner}/{repo}/issues
       │   Create issue
       │
       ├─► PUT /repos/{owner}/{repo}/contents/{path}
       │   Create/update file
       │
       ├─► POST /repos/{owner}/{repo}/pulls
       │   Create pull request
       │
       └─► POST /repos/{owner}/{repo}/pulls/{pr}/reviews
           Submit review
       
       ▲
       │
       │ Webhooks:
       │
       ├── pull_request.opened
       │   Trigger code review
       │
       └── push
           Trigger tests
```

### n8n ↔ File System

```
┌──────────────┐
│     n8n      │
└──────┬───────┘
       │
       │ executeCommand Node:
       │
       ├─► cat <file>
       │   Read files
       │
       ├─► echo "code" > <file>
       │   Write files
       │
       ├─► npm install <package>
       │   Install dependencies
       │
       ├─► npm test
       │   Run tests
       │
       └─► git commands
           Version control
```

## Scaling Architecture

### Parallel Processing

```
                  Project Manager
                        │
                        │ Batch Tasks
                        │
        ┌───────────────┼───────────────┐
        │               │               │
        ▼               ▼               ▼
    UI Agent       Backend Agent   State Agent
        │               │               │
        │ Run in        │ Run in        │ Run in
        │ parallel      │ parallel      │ parallel
        │               │               │
        └───────────────┼───────────────┘
                        │
                        │ Collect Results
                        │
                        ▼
                    Aggregated
                      Output
```

### Error Handling

```
Agent Execution
      │
      ▼
┌─────────────┐
│   Try       │
│   Execute   │
└─────┬───────┘
      │
      ├─── Success ──► Continue
      │
      └─── Error
             │
             ▼
      ┌─────────────┐
      │  Log Error  │
      └─────┬───────┘
             │
             ▼
      ┌─────────────┐
      │  Retry?     │
      └─────┬───────┘
             │
    ┌────────┴────────┐
    │                 │
    ▼                 ▼
  Yes              No
    │                 │
    ▼                 ▼
Retry with      Notify &
backoff         Mark Failed
    │
    └─► Max retries? ──► Fail
```

## Cost Optimization Flow

```
Request
  │
  ▼
┌──────────────────┐
│  Check Cache     │
│  (Response DB)   │
└────┬─────────────┘
     │
     ├─── Hit ───► Return Cached
     │
     └─── Miss
          │
          ▼
     ┌──────────────┐
     │ Rate Limiter │
     └────┬─────────┘
          │
          ▼
     ┌──────────────┐
     │ Check Quota  │
     └────┬─────────┘
          │
          ├─── Within ──► Process
          │
          └─── Exceeded
               │
               ▼
          ┌─────────────┐
          │ Queue or    │
          │ Downgrade   │
          │ to Haiku    │
          └─────────────┘
```

---

## Visual System Overview (All 13 Agents)

```
                    ┌─────────────────────────────┐
                    │      DEVELOPER INPUT        │
                    │   "Create new feature X"    │
                    └─────────────┬───────────────┘
                                  │
                                  ▼
            ┌──────────────────────────────────────────────┐
            │          n8n ORCHESTRATION PLATFORM          │
            │                                              │
            │  ┌────────────────────────────────────────┐  │
            │  │     PROJECT MANAGER AGENT (Core)      │  │
            │  │     • Parse requirements              │  │
            │  │     • Task breakdown                  │  │
            │  │     • Route to specialized agents     │  │
            │  └──────────────┬─────────────────────────┘  │
            │                 │                            │
            │    ┌────────────┼────────────┐              │
            │    │            │            │              │
            │    ▼            ▼            ▼              │
            │  ┌──────────────────────────────────────┐   │
            │  │   DESIGN & PLANNING (Phase 1)        │   │
            │  │                                      │   │
            │  │  ┌────────────┐  ┌────────────┐    │   │
            │  │  │System      │  │API         │    │   │
            │  │  │Design      │  │Design      │    │   │
            │  │  └────────────┘  └────────────┘    │   │
            │  └──────────────────────────────────────┘   │
            │                 │                            │
            │                 ▼                            │
            │  ┌──────────────────────────────────────┐   │
            │  │   DEVELOPMENT (Phase 2)              │   │
            │  │                                      │   │
            │  │  ┌─────┐  ┌─────┐  ┌─────────────┐ │   │
            │  │  │UI   │  │Back │  │Code Review  │ │   │
            │  │  │Gen  │  │End  │  │Agent        │ │   │
            │  │  └─────┘  └─────┘  └─────────────┘ │   │
            │  └──────────────────────────────────────┘   │
            │                 │                            │
            │                 ▼                            │
            │  ┌──────────────────────────────────────┐   │
            │  │   QUALITY & SECURITY (Phase 3)       │   │
            │  │                                      │   │
            │  │  ┌──────┐  ┌──────┐  ┌──────────┐  │   │
            │  │  │Test  │  │Sec   │  │Perf      │  │   │
            │  │  │Agent │  │Agent │  │Agent     │  │   │
            │  │  └──────┘  └──────┘  └──────────┘  │   │
            │  │                                      │   │
            │  │  ┌──────┐  ┌──────┐  ┌──────────┐  │   │
            │  │  │Docs  │  │Trans │  │Refactor  │  │   │
            │  │  │Agent │  │Agent │  │Agent     │  │   │
            │  │  └──────┘  └──────┘  └──────────┘  │   │
            │  └──────────────────────────────────────┘   │
            │                 │                            │
            │                 ▼                            │
            │  ┌──────────────────────────────────────┐   │
            │  │   DEPLOYMENT (Phase 4)               │   │
            │  │                                      │   │
            │  │         ┌──────────┐                │   │
            │  │         │Deploy    │                │   │
            │  │         │Agent     │                │   │
            │  │         └──────────┘                │   │
            │  └──────────────────────────────────────┘   │
            └────────────────────┬───────────────────────┘
                                 │
                      ┌──────────┴──────────┐
                      │                     │
                      ▼                     ▼
              ┌──────────────┐      ┌──────────────┐
              │  Claude AI   │      │   GitHub     │
              │              │      │              │
              │ • Generate   │◄────►│ • Issues     │
              │ • Design     │      │ • PRs        │
              │ • Review     │      │ • Code       │
              │ • Analyze    │      │ • Deployments│
              │ • Optimize   │      │              │
              └──────┬───────┘      └──────┬───────┘
                     │                     │
                     └──────────┬──────────┘
                                │
                                ▼
                ┌──────────────────────────────────┐
                │   COMPLETE DELIVERABLES          │
                │   (All 13 Agents Working)        │
                │                                  │
                │ ✅ System Architecture Designed  │
                │ ✅ API Specifications Created    │
                │ ✅ Components Generated          │
                │ ✅ Services Implemented          │
                │ ✅ Comprehensive Tests Written   │
                │ ✅ Security Audited & Hardened   │
                │ ✅ Performance Optimized         │
                │ ✅ Code Refactored               │
                │ ✅ Full Documentation            │
                │ ✅ Multi-language Support        │
                │ ✅ Deployed to App Stores        │
                └──────────────────────────────────┘
```

## Agent Categories

### Core Orchestration
1. **Project Manager Agent** - Central coordinator

### Phase 1: Design & Planning
2. **System Design Agent** - Architecture design
3. **API Design Agent** - API specifications

### Phase 2: Development
4. **UI Generator Agent** - Component creation
5. **Backend Integration Agent** - API implementation

### Phase 3: Quality & Security
6. **Code Review Agent** - Quality assurance
7. **Testing Agent** - Automated tests
8. **Security Agent** - Security audits
9. **Performance Agent** - Optimization
10. **Refactoring Agent** - Code improvements
11. **Documentation Agent** - Auto-documentation
12. **Translation Agent** - Internationalization

### Phase 4: Deployment
13. **Deploy Agent** - App store automation

---

## Future Agent Architectures

### 5. Testing Agent Flow

```
START (Triggered by Project Manager or Direct)
  │
  ▼
┌────────────────────────────────────────┐
│  Receive Test Generation Task         │
│  - Target file(s)                     │
│  - Test types requested               │
└────────────┬───────────────────────────┘
             │
             ├───────────────────────────┐
             │                           │
             ▼                           ▼
┌────────────────────────┐  ┌─────────────────────────┐
│  Analyze Target Code   │  │  Check Existing Tests   │
│  - Read source file    │  │  - Coverage analysis    │
│  - Identify functions  │  │  - Gap detection        │
│  - Detect dependencies │  └─────────┬───────────────┘
└────────────┬───────────┘            │
             └─────────────┬───────────┘
                           │
                           ▼
┌──────────────────────────────────────────────┐
│  Send to Claude AI                           │
│  "Generate comprehensive tests for:"         │
│  • All public functions                      │
│  • Edge cases                                │
│  • Accessibility                             │
│  • Integration scenarios                     │
└────────────┬─────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Parse Generated Tests                 │
│  - Unit tests                          │
│  - E2E tests                           │
│  - Accessibility tests                 │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Run Tests & Validate                  │
│  - Ensure all pass                     │
│  - Check coverage improvement          │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
  Tests Pass   Tests Fail
      │             │
      ▼             ▼
┌──────────┐  ┌──────────┐
│Create PR │  │Fix Tests │
└──────────┘  └──────────┘
      │
      ▼
    DONE
```

### 6. Documentation Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Code Change Detected                  │
│  (Git commit, PR merge, manual)        │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Analyze Changed Files                 │
│  - Components                          │
│  - Services                            │
│  - Types                               │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Extract Documentation Data            │
│  - TypeScript types                    │
│  - Function signatures                 │
│  - Props interfaces                    │
│  - Usage examples                      │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Send to Claude AI                     │
│  "Generate documentation for:"         │
│  • API reference                       │
│  • Usage guides                        │
│  • Code comments                       │
│  • Changelog entries                   │
└────────────┬───────────────────────────┘
             │
    ┌────────┴────────┬────────┐
    │                 │        │
    ▼                 ▼        ▼
┌─────────┐    ┌──────────┐  ┌──────────┐
│Update   │    │Update    │  │Update    │
│README   │    │API Docs  │  │CHANGELOG │
└────┬────┘    └────┬─────┘  └────┬─────┘
     │              │             │
     └──────┬───────┴─────┬───────┘
            │             │
            ▼             ▼
      ┌──────────┐  ┌──────────┐
      │Commit    │  │Deploy    │
      │Changes   │  │to Docs   │
      └──────────┘  │Site      │
            │       └──────────┘
            ▼
          DONE
```

### 7. Deploy Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Deployment Request                    │
│  - Platform (iOS/Android)              │
│  - Environment (beta/production)       │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Pre-flight Checks                     │
│  - Tests passing?                      │
│  - Version incremented?                │
│  - Changelog updated?                  │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
   Checks        Checks
   Pass          Fail
      │             │
      ▼             ▼
┌──────────┐  ┌──────────┐
│Build App │  │Notify &  │
│          │  │Stop      │
└────┬─────┘  └──────────┘
     │
     ▼
┌────────────────────────────────────────┐
│  Platform-Specific Build               │
│  iOS: Fastlane, Xcode                  │
│  Android: Gradle                       │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Upload to Store                       │
│  iOS: App Store Connect                │
│  Android: Google Play Console          │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Deployment Report            │
│  - Build details                       │
│  - Deployment timeline                 │
│  - Next steps                          │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Notify Team                           │
│  - Slack/Email                         │
│  - TestFlight/Play Console link        │
└────────────┬───────────────────────────┘
             │
             ▼
           DONE
```

### 8. Performance Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Performance Analysis Request          │
│  - Target components                   │
│  - Analysis types                      │
└────────────┬───────────────────────────┘
             │
             ├────────────────┬────────────────┐
             │                │                │
             ▼                ▼                ▼
┌──────────────────┐  ┌──────────────┐  ┌──────────────┐
│Render Profiling  │  │Bundle        │  │Memory        │
│- React DevTools  │  │Analysis      │  │Profiling     │
│- Re-render count │  │- Size check  │  │- Leaks       │
└────────┬─────────┘  └──────┬───────┘  └──────┬───────┘
         │                   │                 │
         └───────────────────┼─────────────────┘
                             │
                             ▼
┌────────────────────────────────────────────────┐
│  Send to Claude AI                             │
│  "Analyze performance data and suggest fixes:" │
│  • Render optimization                         │
│  • Bundle reduction                            │
│  • Memory optimization                         │
└────────────┬───────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Performance Report           │
│  - Issues found                        │
│  - Suggested fixes                     │
│  - Expected improvements               │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
┌──────────┐  ┌──────────┐
│Auto-fix  │  │Manual    │
│Simple    │  │Review    │
│Issues    │  │Complex   │
└────┬─────┘  └──────────┘
     │
     ▼
┌──────────┐
│Create PR │
│with Fixes│
└──────────┘
     │
     ▼
   DONE
```

### 9. Refactoring Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Refactoring Request                   │
│  - Target files/components             │
│  - Refactoring types                   │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Code Quality Analysis                 │
│  - Complexity metrics                  │
│  - Code smells                         │
│  - Duplication detection               │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Send to Claude AI                     │
│  "Suggest refactorings for:"           │
│  • Extract components                  │
│  • Simplify logic                      │
│  • Remove duplication                  │
│  • Apply patterns                      │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Refactoring Suggestions      │
│  - Prioritized by impact               │
│  - With before/after examples          │
│  - Benefits explained                  │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
┌──────────┐  ┌──────────┐
│User      │  │Auto      │
│Approves  │  │Reject    │
└────┬─────┘  └──────────┘
     │
     ▼
┌──────────────────────────────────────────┐
│  Apply Refactoring                       │
│  - Rewrite code                          │
│  - Update imports                        │
│  - Fix references                        │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│  Verify Refactoring                      │
│  - Run tests                             │
│  - Check TypeScript                      │
│  - Verify behavior unchanged             │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────┐
│Create PR │
└──────────┘
     │
     ▼
   DONE
```

### 10. Translation Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  Translation Request                   │
│  - Target files                        │
│  - Languages                           │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Extract Hardcoded Strings             │
│  - Scan JSX/TSX files                  │
│  - Identify text nodes                 │
│  - Detect string literals              │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Translation Keys             │
│  - Create meaningful keys              │
│  - Organize by namespace               │
│  - Handle pluralization                │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Send to Claude AI                     │
│  "Translate to [languages]:"           │
│  • Context-aware translation           │
│  • Cultural adaptation                 │
│  • Maintain tone                       │
└────────────┬───────────────────────────┘
             │
    ┌────────┴────────┬────────┐
    │                 │        │
    ▼                 ▼        ▼
┌─────────┐    ┌──────────┐  ┌──────────┐
│Generate │    │Generate  │  │Generate  │
│en.json  │    │he.json   │  │ar.json   │
└────┬────┘    └────┬─────┘  └────┬─────┘
     │              │             │
     └──────┬───────┴─────┬───────┘
            │             │
            ▼             ▼
      ┌──────────┐  ┌──────────┐
      │Update    │  │Fix RTL   │
      │Components│  │Layout    │
      │Use i18n  │  │Issues    │
      └────┬─────┘  └────┬─────┘
           │             │
           └──────┬──────┘
                  │
                  ▼
┌──────────────────────────────────────────┐
│  Test Translations                       │
│  - Visual verification                   │
│  - RTL/LTR rendering                     │
│  - String interpolation                  │
└────────────┬─────────────────────────────┘
             │
             ▼
           DONE
```

### 11. Security Agent Flow

```
START (Triggered manually, by schedule, or on PR)
  │
  ▼
┌────────────────────────────────────────┐
│  Security Audit Request                │
│  - Scope (full/partial)                │
│  - Target files                        │
└────────────┬───────────────────────────┘
             │
             ├──────────────┬──────────────┬──────────────┬──────────────┐
             │              │              │              │              │
             ▼              ▼              ▼              ▼              ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│Code Analysis │  │Dependency    │  │Config        │  │Auth Review   │  │License       │
│- SQL inject  │  │Scanning      │  │Review        │  │- JWT valid   │  │Compliance 📜 │
│- XSS         │  │- npm audit   │  │- API keys    │  │- Permissions │  │**NEW-CORE**  │
│- Hardcoded   │  │- Snyk scan   │  │- CORS        │  │- Session     │  │- GPL detect  │
│  secrets     │  │- CVE check   │  │- Headers     │  │  mgmt        │  │- Commercial  │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │                 │                 │
       └─────────────────┼─────────────────┼─────────────────┼─────────────────┘
                         │                 │                 │
                         ▼                 ▼                 ▼
              ┌────────────────┐    ┌──────────────┐    ┌──────────────┐
              │Mobile Security │    │OWASP Check   │    │Penetration   │
              │- Root detect   │    │- Top 10      │    │Testing 🛡️    │
              │- Cert pinning  │    │- Mobile Top  │    │**NEW-CORE**  │
              │- Keychain      │    │  10          │    │- SQL inject  │
              └────────┬───────┘    └──────┬───────┘    │- XSS test    │
                       │                   │            │- Auth bypass │
                       │                   │            │- IDOR test   │
                       │                   │            └──────┬───────┘
                       │                   │                   │
                       └─────────┬─────────┴───────────────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────┐
│  Send to Claude AI                             │
│  "Analyze security issues and provide fixes:"  │
│  • Severity classification                     │
│  • OWASP mapping                               │
│  • Fix recommendations                         │
│  • License compliance analysis 📜              │
│  • Penetration test results 🛡️                │
│  • Code examples                               │
└────────────┬───────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Security Report              │
│  - Critical issues (fix immediately)   │
│  - High priority issues                │
│  - Medium/Low issues                   │
│  - License compliance report 📜 NEW    │
│  - Penetration test results 🛡️ NEW     │
│  - Compliance status                   │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
      ▼             ▼
┌──────────┐  ┌──────────┐
│Auto-fix  │  │Manual    │
│Simple    │  │Review    │
│Issues    │  │Critical  │
│- Deps    │  │Issues    │
│- Headers │  │          │
└────┬─────┘  └──────────┘
     │
     ▼
┌──────────────────────────────────────────┐
│  Create PR with Fixes                    │
│  - Updated dependencies                  │
│  - Security headers                      │
│  - Input validation                      │
│  - Encryption                            │
└────────────┬─────────────────────────────┘
             │
             ▼
┌──────────────────────────────────────────┐
│  Update Security Dashboard               │
│  - Vulnerability count                   │
│  - License compliance score 📜 NEW       │
│  - GPL conflicts detected 📜 NEW         │
│  - Pen test pass rate 🛡️ NEW             │
│  - Compliance score                      │
│  - Trend analysis                        │
└────────────┬─────────────────────────────┘
             │
             ▼
           DONE
```

### 12. System Design Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  System Design Request                 │
│  - Requirements                        │
│  - Constraints (budget, tech)          │
│  - Scale expectations                  │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Gather Context                        │
│  - Current architecture (if any)       │
│  - Performance requirements            │
│  - Compliance needs                    │
│  - Integration requirements            │
└────────────┬───────────────────────────┘
             │
             ├──────────────┬──────────────┬──────────────┐
             │              │              │              │
             ▼              ▼              ▼              ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│Database      │  │API           │  │System        │  │Infrastructure│
│Schema Design │  │Architecture  │  │Architecture  │  │Design        │
│- ERD         │  │- REST/GQL    │  │- Components  │  │- Cloud       │
│- Indexes     │  │- Endpoints   │  │- Services    │  │- Scaling     │
│- Migrations  │  │- Security    │  │- Patterns    │  │- DR plan     │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │                 │
       └─────────────────┼─────────────────┼─────────────────┘
                         │                 │
                         ▼                 ▼
              ┌────────────────┐    ┌──────────────┐
              │Tech Stack      │    │Cost Analysis │
              │Recommendations │    │- By service  │
              │- Frontend      │    │- Scaling     │
              │- Backend       │    │- Budget fit  │
              │- Database      │    └──────┬───────┘
              └────────┬───────┘           │
                       └─────────┬─────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────┐
│  Send to Claude AI                             │
│  "Design complete system architecture for:"    │
│  • Scalability planning                        │
│  • Performance targets                         │
│  • Security considerations                     │
│  • Cost optimization                           │
└────────────┬───────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Design Document              │
│  - Architecture diagrams               │
│  - Database schemas                    │
│  - API specifications                  │
│  - Technology recommendations          │
│  - Scalability plan                    │
│  - Cost estimates                      │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Validate Design                       │
│  - Check constraints met               │
│  - Verify scalability                  │
│  - Review security                     │
│  - Confirm budget                      │
└────────────┬───────────────────────────┘
             │
      ┌──────┴──────┐
      │             │
   Valid        Invalid
      │             │
      ▼             ▼
┌──────────┐  ┌──────────┐
│Create    │  │Revise    │
│Design    │  │& Retry   │
│Document  │  └──────────┘
│& Diagrams│
└────┬─────┘
     │
     ▼
┌──────────────────────────────────────────┐
│  Create Implementation Tickets           │
│  - Database setup                        │
│  - API scaffolding                       │
│  - Infrastructure provisioning           │
└────────────┬─────────────────────────────┘
             │
             ▼
           DONE
```

### 13. API Design Agent Flow

```
START
  │
  ▼
┌────────────────────────────────────────┐
│  API Design Request                    │
│  - Feature/domain                      │
│  - Endpoints needed                    │
│  - Auth requirements                   │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Analyze Requirements                  │
│  - Resource modeling                   │
│  - Relationships                       │
│  - Access patterns                     │
└────────────┬───────────────────────────┘
             │
             ├──────────────┬──────────────┬──────────────┐
             │              │              │              │
             ▼              ▼              ▼              ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│Endpoint      │  │Schema        │  │Auth & Authz  │  │Error         │
│Design        │  │Design        │  │Design        │  │Handling      │
│- REST verbs  │  │- Request     │  │- JWT/OAuth   │  │- Status codes│
│- URL struct  │  │- Response    │  │- RBAC        │  │- Messages    │
│- Versioning  │  │- Validation  │  │- API keys    │  │- Recovery    │
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                 │                 │                 │
       └─────────────────┼─────────────────┼─────────────────┘
                         │                 │
                         ▼                 ▼
              ┌────────────────┐    ┌──────────────┐
              │Rate Limiting   │    │Documentation │
              │& Throttling    │    │Strategy      │
              │- Per user      │    │- OpenAPI     │
              │- Per endpoint  │    │- Examples    │
              └────────┬───────┘    └──────┬───────┘
                       └─────────┬─────────┘
                                 │
                                 ▼
┌────────────────────────────────────────────────┐
│  Send to Claude AI                             │
│  "Design RESTful API with:"                    │
│  • Best practices                              │
│  • Security patterns                           │
│  • Performance optimization                    │
│  • Developer experience                        │
└────────────┬───────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate API Specification            │
│  - OpenAPI/Swagger YAML                │
│  - Endpoint documentation              │
│  - Request/response examples           │
│  - Authentication flows                │
│  - Rate limiting rules                 │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Validate Specification                │
│  - Check RESTful compliance            │
│  - Verify security                     │
│  - Test examples                       │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Generate Implementation Guide         │
│  - Code scaffolding                    │
│  - Database queries needed             │
│  - Middleware requirements             │
└────────────┬───────────────────────────┘
             │
             ▼
┌────────────────────────────────────────┐
│  Create PR with API Spec               │
│  - OpenAPI file                        │
│  - README update                       │
│  - Example requests                    │
└────────────┬───────────────────────────┘
             │
             ▼
           DONE
```

## Complete System Architecture (All 13 Agents)

```
                    ┌─────────────────────────────┐
                    │      DEVELOPER INPUT        │
                    │   "Create feature X"        │
                    └─────────────┬───────────────┘
                                  │
                                  ▼
            ┌──────────────────────────────────────────────┐
            │          n8n ORCHESTRATION PLATFORM          │
            │                                              │
            │  ┌────────────────────────────────────────┐  │
            │  │     Project Manager Agent (Core)      │  │
            │  │     • Task breakdown                  │  │
            │  │     • Agent coordination              │  │
            │  └──────────────┬─────────────────────────┘  │
            │                 │                            │
            │   ┌─────────────┼──────────────┐            │
            │   │             │              │            │
            │   ▼             ▼              ▼            │
            │ ┌─────┐      ┌─────┐       ┌─────┐         │
            │ │ UI  │      │Back │       │Code │         │
            │ │Gen  │      │End  │       │Rev  │         │
            │ └──┬──┘      └──┬──┘       └──┬──┘         │
            │    │            │             │            │
            │    ▼            ▼             ▼            │
            │ ┌──────────────────────────────────────┐   │
            │ │     QUALITY & OPTIMIZATION           │   │
            │ │                                      │   │
            │ │  ┌──────┐  ┌──────┐  ┌──────┐      │   │
            │ │  │Test  │  │Perf  │  │Refac │      │   │
            │ │  │Agent │  │Agent │  │Agent │      │   │
            │ │  └──────┘  └──────┘  └──────┘      │   │
            │ └──────────────────────────────────────┘   │
            │                                            │
            │ ┌──────────────────────────────────────┐   │
            │ │     DOCUMENTATION & DEPLOYMENT       │   │
            │ │                                      │   │
            │ │  ┌──────┐  ┌──────┐  ┌──────┐      │   │
            │ │  │Docs  │  │Deploy│  │Trans │      │   │
            │ │  │Agent │  │Agent │  │Agent │      │   │
            │ │  └──────┘  └──────┘  └──────┘      │   │
            │ └──────────────────────────────────────┘   │
            └────────────────────┬───────────────────────┘
                                 │
                      ┌──────────┴──────────┐
                      │                     │
                      ▼                     ▼
              ┌──────────────┐      ┌──────────────┐
              │  Claude AI   │      │   GitHub     │
              │  (Generate)  │      │  (Store)     │
              └──────┬───────┘      └──────┬───────┘
                     │                     │
                     └──────────┬──────────┘
                                │
                                ▼
                ┌──────────────────────────────┐
                │     COMPLETE DELIVERABLES    │
                │                              │
                │  • Developed Code            │
                │  • Comprehensive Tests       │
                │  • Full Documentation        │
                │  • Performance Optimized     │
                │  • Multi-language Support    │
                │  • Deployed to Stores        │
                └──────────────────────────────┘
```

## Agent Collaboration Examples

### Example 1: New Feature Development

```
User Request → Project Manager
                    │
    ┌───────────────┼───────────────────┬──────────┐
    │               │                   │          │
    ▼               ▼                   ▼          ▼
UI Agent      Backend Agent      State Agent  Testing Agent
    │               │                   │          │
    │               │                   │          │
    └───────────────┼───────────────────┴──────────┘
                    │
                    ▼
              Code Review Agent
                    │
                    ▼
            Documentation Agent
                    │
                    ▼
             Translation Agent
                    │
                    ▼
              Performance Agent
                    │
                    ▼
               Deploy Agent
```

### Example 2: Code Optimization

```
Performance Agent (detects issues)
            │
            ▼
    Refactoring Agent (fixes)
            │
            ▼
      Testing Agent (validates)
            │
            ▼
    Code Review Agent (approves)
            │
            ▼
  Documentation Agent (updates docs)
```

## Summary

This architecture provides:
1. **Scalability** - Process multiple tasks in parallel
2. **Flexibility** - Easy to add new agent types
3. **Reliability** - Error handling and retries
4. **Cost Efficiency** - Caching and rate limiting
5. **Quality** - Automated reviews and testing
6. **Speed** - AI-powered generation
7. **Comprehensive Testing** - Automated test coverage (Future)
8. **Always Current Documentation** - Auto-updated docs (Future)
9. **Continuous Deployment** - Minutes to production (Future)
10. **Performance Optimization** - Ongoing improvements (Future)
11. **Code Quality** - Automated refactoring (Future)
12. **Global Reach** - Multi-language support (Future)

The system transforms plain English requirements into production-ready, tested, documented, optimized, and deployed code through a series of specialized AI agents, each focused on specific aspects of development.

**Current State:** 4 agents operational (Project Manager, UI Generator, Code Review, Backend Integration)
**Roadmap:** 9 additional agents planned (Testing, Documentation, Deploy, Performance, Refactoring, Translation, Security, System Design, API Design)
**Total System:** 13 agents providing end-to-end development automation
**Timeline:** Full implementation by Q4 2025
**Expected Impact:** 98%+ reduction in manual development effort (114 hours → 2.22 hours per feature)
