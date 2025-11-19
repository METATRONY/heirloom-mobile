# Placeholder Guide for AI Mobile Agents

This guide explains all available placeholders that can be used in agent configurations and where to use them.

## Overview

Placeholders allow you to customize the AI agents for any mobile app project without manually editing 13+ agent files. The configuration script automatically replaces placeholders with values from your `config/app-config.json`.

## Quick Reference

| Placeholder | Description | Example Value |
|------------|-------------|---------------|
| `{APP_NAME}` | Display name of your app | "Heirloom" |
| `{APP_DESCRIPTION}` | Brief description | "AI-powered family memory app" |
| `{GITHUB_REPO}` | GitHub repository name | "heirloom-mobile" |
| `{GITHUB_OWNER}` | GitHub username/org | "METATRONY" |
| `{PRIMARY_LANGUAGE}` | Primary language code | "he" (Hebrew) |
| `{SUPPORTED_LANGUAGES}` | Comma-separated languages | "he, en" |
| `{TARGET_AUDIENCE}` | Target user type | "elderly users" |
| `{TECH_STACK}` | Technology summary | "React Native + Firebase" |
| `{FRONTEND_FRAMEWORK}` | Frontend framework | "React Native" |
| `{BACKEND_PLATFORM}` | Backend platform | "Firebase" |
| `{DATABASE}` | Database system | "Firestore" |
| `{STATE_MANAGEMENT}` | State management | "Redux Toolkit" |
| `{AUTHENTICATION}` | Auth method | "Firebase Auth" |
| `{ACCESSIBILITY_LEVEL}` | Accessibility level | "enhanced" or "standard" |
| `{WCAG_LEVEL}` | WCAG compliance | "AAA", "AA", or "A" |
| `{RTL_SUPPORT}` | RTL support status | "true" or "false" |
| `{PRIMARY_COLOR}` | Brand primary color | "#4A90E2" |
| `{BUNDLE_ID_IOS}` | iOS bundle identifier | "com.heirloom.mobile" |
| `{BUNDLE_ID_ANDROID}` | Android package name | "com.heirloom.mobile" |

## Detailed Placeholder Definitions

### App Identity

#### `{APP_NAME}`
- **Definition**: `config.app.displayName`
- **Usage**: Agent names, system prompts, commit messages
- **Example**: "Heirloom" → "Your App Name"
- **Locations**: All agent files (name field, system prompts)

#### `{APP_DESCRIPTION}`
- **Definition**: `config.app.description`
- **Usage**: System prompts, documentation generation
- **Example**: "AI-powered family memory recording and preservation app"

#### `{GITHUB_REPO}`
- **Definition**: `config.github.repo`
- **Usage**: Repository references, webhook URLs, GitHub API calls
- **Example**: "heirloom-mobile" → "your-repo-name"
- **Locations**: All agent files (GitHub issue creation, PR URLs)

#### `{GITHUB_OWNER}`
- **Definition**: `config.github.owner`
- **Usage**: GitHub API calls, repository references
- **Example**: "METATRONY" → "your-username"
- **Locations**: All agent files (GitHub owner parameter)

### Internationalization

#### `{PRIMARY_LANGUAGE}`
- **Definition**: `config.languages.primary`
- **Usage**: Translation agent, localization settings
- **Example**: "he" → "en"
- **Applies to**: Translation Agent (13)

#### `{SUPPORTED_LANGUAGES}`
- **Definition**: `config.languages.supported.join(', ')`
- **Usage**: Translation agent, i18n configuration
- **Example**: "he, en" → "en, es, fr"
- **Applies to**: Translation Agent (13), Documentation Agent (08)

#### `{RTL_SUPPORT}`
- **Definition**: `config.languages.rtlSupport.toString()`
- **Usage**: UI generation, component templates
- **Example**: "true" → "false"
- **Applies to**: UI Generator Agent (02), Code Review Agent (03)

### Target Audience

#### `{TARGET_AUDIENCE}`
- **Definition**: `config.targetAudience.type + ' users'`
- **Usage**: System prompts, UX considerations
- **Example**: "elderly users" → "young professionals"
- **Applies to**: All agents (UX context)

#### `{ACCESSIBILITY_LEVEL}`
- **Definition**: `config.targetAudience.accessibilityLevel`
- **Usage**: UI generation, code review checks
- **Example**: "enhanced" → "standard"
- **Applies to**: UI Generator (02), Code Review (03), Testing (07)

#### `{WCAG_LEVEL}`
- **Definition**: `config.accessibility.wcagLevel`
- **Usage**: Accessibility testing, code review
- **Example**: "AAA" → "AA"
- **Applies to**: Code Review (03), Testing (07), Security (06)

### Technology Stack

#### `{TECH_STACK}`
- **Definition**: `config.techStack.frontend + ' + ' + config.techStack.backend`
- **Usage**: System prompts, architectural decisions
- **Example**: "React Native + Firebase" → "React Native + Node.js"
- **Applies to**: All agents (technical context)

#### `{FRONTEND_FRAMEWORK}`
- **Definition**: `config.techStack.frontend`
- **Usage**: Component generation, testing
- **Example**: "React Native"
- **Applies to**: UI Generator (02), Testing (07), Performance (11)

#### `{BACKEND_PLATFORM}`
- **Definition**: `config.techStack.backend`
- **Usage**: Backend integration, API design
- **Example**: "Firebase" → "Node.js + Express"
- **Applies to**: Backend Integration (04), API Design (09), Security (06)

#### `{DATABASE}`
- **Definition**: `config.techStack.database`
- **Usage**: Data modeling, query optimization
- **Example**: "Firestore" → "PostgreSQL"
- **Applies to**: Backend Integration (04), Performance (11), Security (06)

#### `{STATE_MANAGEMENT}`
- **Definition**: `config.techStack.stateManagement`
- **Usage**: State architecture, testing
- **Example**: "Redux Toolkit" → "MobX"
- **Applies to**: UI Generator (02), System Design (05), Testing (07)

#### `{AUTHENTICATION}`
- **Definition**: `config.techStack.authentication`
- **Usage**: Auth implementation, security
- **Example**: "Firebase Auth" → "Auth0"
- **Applies to**: Backend Integration (04), Security (06), Testing (07)

### Design System

#### `{PRIMARY_COLOR}`
- **Definition**: `config.design.primaryColor`
- **Usage**: UI component generation, theming
- **Example**: "#4A90E2" → "#FF5733"
- **Applies to**: UI Generator (02), Documentation (08)

#### `{BASE_FONT_SIZE}`
- **Definition**: `config.design.typography.baseFontSize`
- **Usage**: Typography system, accessibility
- **Example**: "18" → "16"
- **Applies to**: UI Generator (02), Code Review (03)

### Deployment

#### `{BUNDLE_ID_IOS}`
- **Definition**: `config.deployment.bundleId.ios`
- **Usage**: iOS build configuration
- **Example**: "com.heirloom.mobile" → "com.yourcompany.app"
- **Applies to**: Deploy Agent (10)

#### `{BUNDLE_ID_ANDROID}`
- **Definition**: `config.deployment.bundleId.android`
- **Usage**: Android build configuration
- **Example**: "com.heirloom.mobile" → "com.yourcompany.app"
- **Applies to**: Deploy Agent (10)

## Conditional Placeholders

These placeholders appear/disappear based on configuration values:

### `{RTL_FIXES}`
**Condition**: `config.languages.rtlSupport === true`
**Value**: "Ensure proper RTL layout support for languages like Hebrew and Arabic. Check text alignment, flex direction, and icon positioning."
**Default**: "" (empty)
**Applies to**: UI Generator (02), Code Review (03), Translation (13)

### `{ACCESSIBILITY_REQUIREMENTS}`
**Condition**: `config.targetAudience.accessibilityLevel === 'enhanced'`
**Value**: "Enhanced accessibility: minimum touch target 48px, high contrast mode, large text default, screen reader optimization, WCAG {WCAG_LEVEL} compliance."
**Default**: "Standard accessibility: follow WCAG {WCAG_LEVEL} guidelines."
**Applies to**: UI Generator (02), Code Review (03), Testing (07)

### `{ELDERLY_OPTIMIZATIONS}`
**Condition**: `config.targetAudience.type === 'elderly' || config.targetAudience.ageGroup === 'elderly'`
**Value**: "Elderly user optimizations: larger fonts (min 18px), high contrast, simple navigation, voice input support, error forgiveness."
**Default**: "" (empty)
**Applies to**: UI Generator (02), Testing (07), Documentation (08)

### `{FIREBASE_INTEGRATION}`
**Condition**: `config.techStack.backend.includes('Firebase')`
**Value**: "Use Firebase SDK best practices: optimize reads, use collections efficiently, implement offline persistence."
**Default**: "" (empty)
**Applies to**: Backend Integration (04), Performance (11), Security (06)

### `{SECURITY_STANDARDS}`
**Condition**: Always present, uses `config.agents.customization.security.complianceStandards`
**Value**: "Comply with: {STANDARDS}" (e.g., "OWASP Top 10, OWASP Mobile Top 10")
**Applies to**: Security Agent (06), Code Review (03)

## Where Placeholders Are Used

### Agent JSON Structure

Each agent file (`agents/XX-agent-name.json`) has this structure:

```json
{
  "name": "{APP_NAME} Agent Name",  // ← Placeholder here
  "nodes": [
    {
      "parameters": {
        "bodyParametersJson": "={
          \"model\": \"claude-sonnet-4-20250514\",
          \"messages\": [{
            \"role\": \"user\",
            \"content\": \"You are an agent for {APP_NAME}...\"  // ← Placeholder here
          }]
        }",
        "owner": "={{ $json.github_owner }}",  // ← Dynamic from webhook, but default in prompts
        "repository": "={{ $json.github_repo }}"  // ← Dynamic from webhook, but default in prompts
      }
    }
  ]
}
```

### System Prompt Locations

System prompts are embedded in the `bodyParametersJson` field of HTTP Request nodes that call Claude API:

1. **Project Manager Agent (01)**: Node "Analyze Requirements (Claude)"
2. **UI Generator Agent (02)**: Node "Generate UI Components (Claude)"
3. **Code Review Agent (03)**: Node "Analyze Code (Claude)"
4. **Backend Integration Agent (04)**: Node "Generate Backend Code (Claude)"
5. **System Design Agent (05)**: Node "Design System Architecture (Claude)"
6. **Security Agent (06)**: Node "Analyze Security (Claude)"
7. **Testing Agent (07)**: Node "Generate Tests (Claude)"
8. **Documentation Agent (08)**: Node "Generate Documentation (Claude)"
9. **API Design Agent (09)**: Node "Design API (Claude)"
10. **Deploy Agent (10)**: Node "Prepare Deployment (Claude)"
11. **Performance Agent (11)**: Node "Analyze Performance (Claude)"
12. **Refactoring Agent (12)**: Node "Suggest Refactoring (Claude)"
13. **Translation Agent (13)**: Node "Translate Content (Claude)"

## How to Add New Placeholders

### 1. Define in `config/agent-prompts-template.json`

```json
{
  "placeholderDefinitions": {
    "MY_NEW_PLACEHOLDER": "config.path.to.value",
    "COMPLEX_PLACEHOLDER": "config.value1 + ' and ' + config.value2"
  }
}
```

### 2. Use in Agent Templates

```json
{
  "templates": {
    "agentName": {
      "systemPrompt": "You are working with {MY_NEW_PLACEHOLDER}..."
    }
  }
}
```

### 3. Add to This Guide

Document the new placeholder in this file with:
- Definition (JavaScript expression)
- Usage (where and why it's used)
- Example values
- Which agents use it

## Testing Placeholders

After adding or modifying placeholders:

```bash
# 1. Validate your configuration
npm run validate

# 2. Apply configuration to agents
npm run configure

# 3. Check specific agent file
cat agents/01-project-manager-agent.json | grep "YOUR_PLACEHOLDER"

# 4. Reset if needed
npm run reset
```

## Common Patterns

### Simple Text Replacement
```javascript
"{APP_NAME}" → config.app.displayName
```

### Concatenation
```javascript
"{TECH_STACK}" → config.techStack.frontend + " + " + config.techStack.backend
```

### Array Join
```javascript
"{SUPPORTED_LANGUAGES}" → config.languages.supported.join(", ")
```

### Conditional (with ternary)
```javascript
"{FEATURE_STATUS}" → config.features.darkMode ? "enabled" : "disabled"
```

### Nested Object Access
```javascript
"{BUNDLE_ID}" → config.deployment.bundleId.ios
```

## Troubleshooting

### Placeholder Not Replaced
1. Check spelling: `{APP_NAME}` not `{app_name}`
2. Verify definition in `agent-prompts-template.json`
3. Check if configuration value exists in `app-config.json`
4. Run `npm run configure` again

### Placeholder Evaluation Error
```
⚠️  Warning: Could not evaluate placeholder: ...
```
- Usually means the JavaScript expression is invalid
- Check for syntax errors in placeholder definition
- Ensure all referenced config paths exist

### Unexpected Value
1. Check `config/app-config.json` has the correct value
2. Verify placeholder definition uses correct path
3. Test with: `node -e "const config = require('./config/app-config.json'); console.log(YOUR_EXPRESSION)"`

## Examples

### Heirloom Configuration (Current)

```json
{
  "app": { "displayName": "Heirloom" },
  "languages": { "primary": "he", "rtlSupport": true },
  "targetAudience": { "type": "elderly" }
}
```

Results in:
- `{APP_NAME}` → "Heirloom"
- `{PRIMARY_LANGUAGE}` → "he"
- `{RTL_SUPPORT}` → "true"
- `{RTL_FIXES}` → "Ensure proper RTL layout support..." (conditional active)
- `{ELDERLY_OPTIMIZATIONS}` → "Elderly user optimizations..." (conditional active)

### E-commerce App Example

```json
{
  "app": { "displayName": "ShopNow" },
  "languages": { "primary": "en", "rtlSupport": false },
  "targetAudience": { "type": "shoppers" }
}
```

Results in:
- `{APP_NAME}` → "ShopNow"
- `{PRIMARY_LANGUAGE}` → "en"
- `{RTL_SUPPORT}` → "false"
- `{RTL_FIXES}` → "" (conditional inactive)
- `{ELDERLY_OPTIMIZATIONS}` → "" (conditional inactive)

---

**Need Help?** See [CUSTOMIZATION_GUIDE.md](CUSTOMIZATION_GUIDE.md) for step-by-step instructions.
