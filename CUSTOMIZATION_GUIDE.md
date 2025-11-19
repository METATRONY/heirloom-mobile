# AI Mobile Agents - Customization Guide

**Transform this system for YOUR mobile app in 15-30 minutes!**

---

## 🎯 Quick Start (15 minutes)

### Step 1: Copy Configuration Template (2 min)

```bash
cp config/app-config.example.json config/app-config.json
```

### Step 2: Edit Your App Details (10 min)

Open `config/app-config.json` and update:

```json
{
  "app": {
    "name": "MyApp",                    // ← Your app name (code-friendly)
    "displayName": "My Awesome App",   // ← Display name
    "description": "What your app does"
  },
  "github": {
    "owner": "your-username",          // ← Your GitHub username/org
    "repo": "your-repo-name"           // ← Your repository name
  },
  "languages": {
    "primary": "en",                   // ← Primary language
    "supported": ["en", "es"],        // ← Add all languages
    "rtlSupport": false               // ← true if using Hebrew/Arabic
  },
  "targetAudience": {
    "type": "general",                 // ← Options: general, elderly, children
    "accessibilityLevel": "standard"   // ← standard or enhanced
  }
}
```

**💡 Tip:** Leave other fields as-is for now. You can customize them later!

### Step 3: Validate Configuration (1 min)

```bash
npm run validate
```

This checks your config for errors and shows warnings if needed.

### Step 4: Configure Agents (2 min)

```bash
npm run configure
```

This applies your configuration to all 13 AI agents automatically!

### Step 5: You're Done! 🎉

Import the configured agents into n8n and start building!

---

## 📚 Detailed Configuration

### App Settings

```json
{
  "app": {
    "name": "MyApp",
    "displayName": "My Awesome App",
    "description": "Brief description",
    "version": "1.0.0"
  }
}
```

- **name**: Code-friendly name (no spaces, lowercase recommended)
- **displayName**: Human-readable name (used in prompts and docs)
- **description**: One-line summary of your app
- **version**: Current version number

### GitHub Integration

```json
{
  "github": {
    "owner": "your-org",
    "repo": "your-repo",
    "defaultBranch": "main"
  }
}
```

All agents will use these values to create issues, PRs, and comments.

### Language & Internationalization

```json
{
  "languages": {
    "primary": "en",
    "supported": ["en", "es", "fr"],
    "rtlSupport": false
  }
}
```

**Examples:**

**English only:**
```json
{
  "primary": "en",
  "supported": ["en"],
  "rtlSupport": false
}
```

**English + Spanish:**
```json
{
  "primary": "en",
  "supported": ["en", "es"],
  "rtlSupport": false
}
```

**Hebrew + English (RTL):**
```json
{
  "primary": "he",
  "supported": ["he", "en"],
  "rtlSupport": true
}
```

### Target Audience

```json
{
  "targetAudience": {
    "type": "general",        // Options: general, elderly, children, professionals
    "ageGroup": "all",        // Options: all, elderly, young-adults, children
    "accessibilityLevel": "standard"  // Options: standard, enhanced
  }
}
```

**For elderly users:**
```json
{
  "type": "elderly",
  "ageGroup": "elderly",
  "accessibilityLevel": "enhanced"
}
```

This will:
- Generate larger touch targets (min 48px instead of 44px)
- Use higher contrast colors
- Simplify UI patterns
- Add extra accessibility labels
- Use formal, clear language

### Accessibility Settings

```json
{
  "accessibility": {
    "wcagLevel": "AA",               // A, AA, or AAA
    "minimumTouchTargetSize": 44,    // pixels
    "highContrastMode": false,
    "largeTextDefault": false,
    "screenReaderOptimized": true
  }
}
```

**Standard (WCAG AA):**
```json
{
  "wcagLevel": "AA",
  "minimumTouchTargetSize": 44,
  "highContrastMode": false,
  "largeTextDefault": false
}
```

**Enhanced (for elderly or vision-impaired):**
```json
{
  "wcagLevel": "AAA",
  "minimumTouchTargetSize": 48,
  "highContrastMode": true,
  "largeTextDefault": true
}
```

### Tech Stack

```json
{
  "techStack": {
    "frontend": "React Native",
    "stateManagement": "Redux Toolkit",
    "backend": "Firebase",
    "database": "Firestore",
    "authentication": "Firebase Auth",
    "storage": "Firebase Storage",
    "preferredLibraries": ["react-query", "zustand"]
  }
}
```

**AWS Backend:**
```json
{
  "backend": "AWS",
  "database": "DynamoDB",
  "authentication": "AWS Cognito",
  "storage": "S3"
}
```

**PostgreSQL Backend:**
```json
{
  "backend": "Node.js + Express",
  "database": "PostgreSQL",
  "authentication": "JWT",
  "storage": "S3"
}
```

### Design System

```json
{
  "design": {
    "styleGuideUrl": "https://your-design-system.com",
    "primaryColor": "#007AFF",
    "brandColors": {
      "primary": "#007AFF",
      "secondary": "#5856D6",
      "accent": "#FF9500",
      "background": "#FFFFFF",
      "text": "#000000"
    },
    "typography": {
      "fontFamily": "Inter",
      "baseFontSize": 16
    },
    "spacing": {
      "baseUnit": 8
    }
  }
}
```

**💡 Tip:** If you don't have a style guide URL, leave it empty. Agents will use React Native best practices.

### Features

```json
{
  "features": {
    "authentication": true,
    "pushNotifications": true,
    "offlineMode": true,
    "analytics": true,
    "darkMode": true,
    "inAppPurchases": false,
    "socialSharing": false
  }
}
```

Enable/disable features to inform agent recommendations.

### Agent Customization

```json
{
  "agents": {
    "enabled": ["all"],
    "disabled": [],
    "customization": {
      "codeReview": {
        "strictness": "medium",     // low, medium, high
        "autoApprove": false
      },
      "translation": {
        "translationService": "claude",
        "contextAware": true
      },
      "security": {
        "scanFrequency": "weekly",
        "autoFix": false
      }
    }
  }
}
```

---

## 🔧 Advanced Customization

### Custom System Prompts

After running `npm run configure`, you can manually edit system prompts in agent JSON files:

**Example: UI Generator** (`agents/02-ui-generator-agent.json`)

Find the node with `"name": "Generate Component (Claude)"` and edit the `bodyParametersJson`:

```json
{
  "model": "claude-sonnet-4-20250514",
  "system": "You are an expert React Native developer for [YOUR APP]...",
  "messages": [...]
}
```

### Disable Specific Agents

In `config/app-config.json`:

```json
{
  "agents": {
    "enabled": ["all"],
    "disabled": ["translation", "deploy"]
  }
}
```

### Change AI Model

```json
{
  "ai": {
    "provider": "anthropic",
    "model": "claude-sonnet-4-20250514",  // or claude-opus-4-20250514
    "maxTokens": 4000,
    "temperature": 0.7
  }
}
```

**Models:**
- `claude-sonnet-4-20250514` - Fast, balanced (recommended)
- `claude-opus-4-20250514` - Most capable, slower, expensive
- `claude-haiku-4-20250514` - Fastest, cheapest, less capable

---

## 🎨 Use Case Examples

### E-Commerce App

```json
{
  "app": {
    "name": "ShopNow",
    "displayName": "ShopNow"
  },
  "targetAudience": {
    "type": "general"
  },
  "features": {
    "authentication": true,
    "offlineMode": false,
    "inAppPurchases": true,
    "socialSharing": true
  },
  "design": {
    "primaryColor": "#FF6B6B"
  }
}
```

### Fitness Tracking App

```json
{
  "app": {
    "name": "FitTrack",
    "displayName": "FitTrack Pro"
  },
  "targetAudience": {
    "type": "professionals",
    "ageGroup": "young-adults"
  },
  "features": {
    "analytics": true,
    "pushNotifications": true,
    "darkMode": true
  },
  "techStack": {
    "backend": "AWS",
    "database": "PostgreSQL"
  }
}
```

### Senior Citizen Health App

```json
{
  "app": {
    "name": "HealthCare",
    "displayName": "HealthCare Assistant"
  },
  "targetAudience": {
    "type": "elderly",
    "ageGroup": "elderly",
    "accessibilityLevel": "enhanced"
  },
  "accessibility": {
    "wcagLevel": "AAA",
    "minimumTouchTargetSize": 48,
    "highContrastMode": true,
    "largeTextDefault": true
  },
  "design": {
    "typography": {
      "baseFontSize": 18
    }
  }
}
```

### Educational Kids App

```json
{
  "app": {
    "name": "LearnPlay",
    "displayName": "LearnPlay Kids"
  },
  "targetAudience": {
    "type": "children",
    "ageGroup": "children",
    "accessibilityLevel": "enhanced"
  },
  "languages": {
    "primary": "en",
    "supported": ["en", "es", "fr"]
  },
  "design": {
    "primaryColor": "#FFB300",
    "typography": {
      "baseFontSize": 18
    }
  }
}
```

---

## 🧪 Testing Your Configuration

### 1. Validate Config

```bash
npm run validate
```

Checks for:
- ✅ Required fields present
- ✅ Valid formats (colors, bundle IDs)
- ⚠️ Example values still in use
- ⚠️ Mismatched settings (RTL languages without RTL support)

### 2. Configure Agents

```bash
npm run configure
```

Applies your config to all 13 agents.

### 3. Test with Sample Request

```bash
# Test Project Manager Agent
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create a login screen with email and password",
    "github_owner": "your-username",
    "github_repo": "your-repo"
  }'
```

---

## 🔄 Resetting to Template

If you want to start over:

```bash
npm run reset
```

This resets all agents to their template state. Your `config/app-config.json` is NOT affected.

---

## ❓ Troubleshooting

### "config/app-config.json not found"

**Solution:**
```bash
cp config/app-config.example.json config/app-config.json
```

### "Invalid JSON" error

**Solution:**
- Check for missing commas
- Validate JSON at [jsonlint.com](https://jsonlint.com/)
- Compare with `app-config.example.json`

### Agents still reference "Heirloom"

**Solution:**
- Check that you ran `npm run configure`
- Verify `app.displayName` in config is set correctly
- Try `npm run reset && npm run configure`

### Generated code doesn't match my needs

**Solution:**
1. Update relevant sections in `config/app-config.json`
2. Run `npm run configure` again
3. For fine-tuning, manually edit system prompts in agent JSON files

---

## 📖 Next Steps

1. **Import to n8n**: Import all configured agents from `agents/` directory
2. **Set Credentials**: Configure Anthropic API and GitHub token in n8n
3. **Activate Workflows**: Enable all agents in n8n UI
4. **Start Building**: Send your first request to Project Manager Agent!

---

## 💡 Pro Tips

1. **Start Simple**: Use default values for most settings initially
2. **Iterate**: Refine configuration based on generated output
3. **Test Early**: Test each agent individually before full workflow
4. **Version Control**: Keep your `config/app-config.json` in version control
5. **Document Customizations**: Add notes in config for future reference

---

**Need help? Check [README.md](README.md) or open a GitHub issue!**
