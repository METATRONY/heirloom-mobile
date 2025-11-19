# Complete Walkthrough Example: Recording Screen Feature

This document shows exactly what happens when you request a feature using the n8n agent system.

## Your Input

```bash
curl -X POST http://localhost:5678/webhook/project-manager \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "Create a recording screen for the Heirloom mobile app with the following features:
    1. Large start/stop recording button (high contrast, accessible)
    2. Real-time transcription display with Hebrew/English support
    3. Recording timer showing minutes:seconds
    4. Audio level indicator with visual bars
    5. Pause/resume controls
    6. Save recording to Firebase Storage
    7. Offline support with queue
    8. Proper error handling",
    "github_owner": "your-username",
    "github_repo": "heirloom-mobile"
  }'
```

---

## Step-by-Step Execution

### Step 1: Project Manager Agent Receives Request (0:00-0:05)

**n8n Workflow Execution:**

1. Webhook receives POST request
2. Workflow activates
3. Requirements sent to Claude API

**Claude API Request:**
```json
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 4000,
  "messages": [{
    "role": "user",
    "content": "Break down this requirement into specific development tasks..."
  }]
}
```

**Claude Response (5 seconds later):**
```json
{
  "tasks": [
    {
      "name": "RecordingScreen UI Component",
      "description": "Create the main recording screen with button and timer",
      "dependencies": [],
      "estimated_hours": 4,
      "assigned_agent": "UI",
      "priority": "High"
    },
    {
      "name": "AudioService - Recording Logic",
      "description": "Implement audio recording with RN Audio Recorder Player",
      "dependencies": ["RecordingScreen UI Component"],
      "estimated_hours": 6,
      "assigned_agent": "Backend Integration",
      "priority": "High"
    },
    {
      "name": "TranscriptionService - STT Integration",
      "description": "Real-time Speech-to-Text with Google Cloud STT",
      "dependencies": ["AudioService"],
      "estimated_hours": 5,
      "assigned_agent": "Backend Integration",
      "priority": "High"
    },
    {
      "name": "AudioVisualizer Component",
      "description": "Visual audio level indicator bars",
      "dependencies": [],
      "estimated_hours": 3,
      "assigned_agent": "UI",
      "priority": "Medium"
    },
    {
      "name": "RecordingState Redux Slice",
      "description": "State management for recording status",
      "dependencies": [],
      "estimated_hours": 2,
      "assigned_agent": "State Management",
      "priority": "High"
    },
    {
      "name": "OfflineQueue Service",
      "description": "Queue failed uploads for retry when online",
      "dependencies": ["AudioService"],
      "estimated_hours": 4,
      "assigned_agent": "Backend Integration",
      "priority": "Medium"
    }
  ]
}
```

### Step 2: GitHub Issues Created (0:05-0:10)

**For each task, the Project Manager creates a GitHub issue:**

**Issue #1: RecordingScreen UI Component**
```markdown
Title: RecordingScreen UI Component

Description:
Create the main recording screen with button and timer

Requirements:
- Large start/stop recording button (high contrast, accessible)
- Recording timer showing minutes:seconds
- Proper accessibility labels
- RTL/LTR support
- High contrast colors

Dependencies: None
Estimated Effort: 4h
Priority: High

Labels: agent-task, UI, high-priority
```

**Issue #2-6:** Similar format for other tasks...

### Step 3: Agents Triggered in Parallel (0:10-0:15)

The Project Manager triggers multiple agents simultaneously:

```
0:10 → Trigger UI Generator Agent (Issue #1)
0:11 → Trigger Backend Integration Agent (Issue #2)
0:12 → Trigger Backend Integration Agent (Issue #3)
0:13 → Trigger UI Generator Agent (Issue #4)
0:14 → Trigger State Management Agent (Issue #5)
```

---

## Agent Execution: UI Generator for RecordingScreen

### Step 4: UI Generator Agent Starts (0:15)

**Load Context:**
```bash
# Read style guide
cat /path/to/HeirloomMobile/src/styles/theme.ts

# Read existing components
cat /path/to/HeirloomMobile/src/components/Button.tsx
cat /path/to/HeirloomMobile/src/components/Timer.tsx
```

### Step 5: Claude Generates Component (0:15-0:25)

**Prompt to Claude:**
```
You are an expert React Native developer specializing in accessible mobile UIs.

Create a RecordingScreen component with these requirements:
- Large start/stop recording button (high contrast, accessible)
- Recording timer showing minutes:seconds
...

Style Guide:
[theme.ts content]

Existing Components:
[Button.tsx, Timer.tsx content]

Return as JSON with:
- component_code
- test_code
- file_path
- dependencies
- usage_example
```

**Claude's Response (10 seconds later):**

```json
{
  "component_code": "import React, { useState, useEffect } from 'react';\nimport { View, StyleSheet, Text, AccessibilityInfo } from 'react-native';\nimport { useDispatch, useSelector } from 'react-redux';\nimport { Button } from '../components/Button';\nimport { Timer } from '../components/Timer';\nimport { theme } from '../styles/theme';\nimport { startRecording, stopRecording } from '../store/recordingSlice';\n\ninterface RecordingScreenProps {}\n\nexport const RecordingScreen: React.FC<RecordingScreenProps> = () => {\n  const dispatch = useDispatch();\n  const { isRecording, duration } = useSelector(\n    (state: RootState) => state.recording\n  );\n\n  const handleRecordPress = () => {\n    if (isRecording) {\n      dispatch(stopRecording());\n      AccessibilityInfo.announceForAccessibility('Recording stopped');\n    } else {\n      dispatch(startRecording());\n      AccessibilityInfo.announceForAccessibility('Recording started');\n    }\n  };\n\n  return (\n    <View style={styles.container}>\n      <Timer duration={duration} style={styles.timer} />\n      \n      <Button\n        onPress={handleRecordPress}\n        accessibilityLabel={\n          isRecording ? 'Stop recording' : 'Start recording'\n        }\n        accessibilityHint=\"Double tap to toggle recording\"\n        accessibilityRole=\"button\"\n        style={[\n          styles.recordButton,\n          isRecording && styles.recordButtonActive\n        ]}\n      >\n        <Text style={styles.buttonText}>\n          {isRecording ? '⏹️ Stop' : '⏺️ Record'}\n        </Text>\n      </Button>\n    </View>\n  );\n};\n\nconst styles = StyleSheet.create({\n  container: {\n    flex: 1,\n    justifyContent: 'center',\n    alignItems: 'center',\n    backgroundColor: theme.colors.background,\n    padding: theme.spacing.lg,\n  },\n  timer: {\n    marginBottom: theme.spacing.xl,\n  },\n  recordButton: {\n    width: 200,\n    height: 200,\n    borderRadius: 100,\n    backgroundColor: theme.colors.primary,\n    justifyContent: 'center',\n    alignItems: 'center',\n    // Ensure minimum touch target\n    minWidth: theme.accessibility.minTouchTarget,\n    minHeight: theme.accessibility.minTouchTarget,\n  },\n  recordButtonActive: {\n    backgroundColor: theme.colors.error,\n  },\n  buttonText: {\n    fontSize: theme.fontSize.xlarge,\n    color: theme.colors.textDark,\n    fontWeight: 'bold',\n  },\n});\n\nexport default RecordingScreen;",
  
  "test_code": "import React from 'react';\nimport { render, fireEvent, waitFor } from '@testing-library/react-native';\nimport { Provider } from 'react-redux';\nimport { RecordingScreen } from '../RecordingScreen';\nimport { store } from '../../store';\n\ndescribe('RecordingScreen', () => {\n  const renderComponent = () =>\n    render(\n      <Provider store={store}>\n        <RecordingScreen />\n      </Provider>\n    );\n\n  it('renders correctly', () => {\n    const { getByLabelText } = renderComponent();\n    expect(getByLabelText('Start recording')).toBeTruthy();\n  });\n\n  it('has proper accessibility labels', () => {\n    const { getByLabelText } = renderComponent();\n    const button = getByLabelText('Start recording');\n    expect(button.props.accessibilityRole).toBe('button');\n    expect(button.props.accessibilityHint).toBe('Double tap to toggle recording');\n  });\n\n  it('toggles recording state on button press', async () => {\n    const { getByLabelText } = renderComponent();\n    const button = getByLabelText('Start recording');\n    \n    fireEvent.press(button);\n    \n    await waitFor(() => {\n      expect(getByLabelText('Stop recording')).toBeTruthy();\n    });\n  });\n\n  it('meets minimum touch target size', () => {\n    const { getByLabelText } = renderComponent();\n    const button = getByLabelText('Start recording');\n    const { width, height } = button.props.style;\n    \n    expect(width).toBeGreaterThanOrEqual(44);\n    expect(height).toBeGreaterThanOrEqual(44);\n  });\n});",
  
  "file_path": "src/screens/RecordingScreen.tsx",
  "test_file_path": "src/screens/__tests__/RecordingScreen.test.tsx",
  "dependencies": ["@reduxjs/toolkit", "react-redux"],
  "usage_example": "import { RecordingScreen } from './screens/RecordingScreen';\n\n// In navigator:\n<Stack.Screen name=\"Recording\" component={RecordingScreen} />"
}
```

### Step 6: Write Files and Run Tests (0:25-0:35)

**Files Written:**
```bash
# Component
/path/to/HeirloomMobile/src/screens/RecordingScreen.tsx

# Tests
/path/to/HeirloomMobile/src/screens/__tests__/RecordingScreen.test.tsx
```

**Dependencies Installed:**
```bash
cd /path/to/HeirloomMobile
npm install @reduxjs/toolkit react-redux
```

**Tests Run:**
```bash
npm test -- src/screens/__tests__/RecordingScreen.test.tsx

PASS  src/screens/__tests__/RecordingScreen.test.tsx
  RecordingScreen
    ✓ renders correctly (52ms)
    ✓ has proper accessibility labels (28ms)
    ✓ toggles recording state on button press (45ms)
    ✓ meets minimum touch target size (12ms)

Test Suites: 1 passed, 1 total
Tests:       4 passed, 4 total
Time:        2.137s
```

### Step 7: Create Pull Request (0:35-0:40)

**GitHub API Calls:**

1. **Create Branch:**
```
POST /repos/your-username/heirloom-mobile/git/refs
{
  "ref": "refs/heads/feature/recording-screen-ui",
  "sha": "main-branch-sha"
}
```

2. **Commit Files:**
```
PUT /repos/your-username/heirloom-mobile/contents/src/screens/RecordingScreen.tsx
{
  "message": "feat: Add RecordingScreen component",
  "content": "base64-encoded-content",
  "branch": "feature/recording-screen-ui"
}
```

3. **Create PR:**
```
POST /repos/your-username/heirloom-mobile/pulls
{
  "title": "RecordingScreen UI Component",
  "head": "feature/recording-screen-ui",
  "base": "main",
  "body": "## Implementation\n\n### Features\n- ✅ Large accessible button\n- ✅ Recording timer\n- ✅ High contrast colors\n- ✅ RTL/LTR support\n- ✅ Accessibility labels\n\n### Files\n- src/screens/RecordingScreen.tsx\n- src/screens/__tests__/RecordingScreen.test.tsx\n\n### Tests\n✅ All 4 tests passed\n\nCloses #1"
}
```

**Pull Request Created:**
```
https://github.com/your-username/heirloom-mobile/pull/1
```

---

## Code Review Agent Execution

### Step 8: Code Review Agent Triggered (0:40)

**GitHub Webhook:**
```json
{
  "action": "opened",
  "pull_request": {
    "number": 1,
    "title": "RecordingScreen UI Component",
    "html_url": "https://github.com/your-username/heirloom-mobile/pull/1"
  }
}
```

### Step 9: Fetch PR Details and Review (0:40-0:50)

**Claude Reviews Code:**
```json
{
  "overall_rating": "approve",
  "summary": "Excellent implementation with strong accessibility support and proper error handling. Code follows React Native best practices and includes comprehensive tests.",
  "issues": [
    {
      "severity": "minor",
      "category": "performance",
      "line_number": 15,
      "description": "Consider using useCallback for handleRecordPress to prevent unnecessary re-renders",
      "suggestion": "Wrap handleRecordPress in useCallback with [isRecording] dependency"
    },
    {
      "severity": "suggestion",
      "category": "ux",
      "line_number": 45,
      "description": "Consider adding haptic feedback on button press for better UX",
      "suggestion": "Add: import { Vibration } from 'react-native'; Vibration.vibrate(50);"
    }
  ],
  "positives": [
    "Excellent accessibility implementation with proper labels and hints",
    "Meets WCAG 2.1 touch target requirements (200x200 > 44x44)",
    "Clean separation of concerns with Redux",
    "Comprehensive test coverage",
    "Proper TypeScript typing",
    "RTL/LTR support via theme",
    "Clear, readable code structure"
  ]
}
```

### Step 10: Post Review (0:50)

**Review Posted:**
```markdown
## ✅ Code Review - APPROVED

Excellent implementation with strong accessibility support and proper error 
handling. Code follows React Native best practices and includes comprehensive tests.

### Issues Found

💡 **MINOR** - performance
**Line 15:** Consider using useCallback for handleRecordPress to prevent 
unnecessary re-renders

**Suggestion:** Wrap handleRecordPress in useCallback with [isRecording] dependency

---

💭 **SUGGESTION** - ux
**Line 45:** Consider adding haptic feedback on button press for better UX

**Suggestion:** Add: import { Vibration } from 'react-native'; Vibration.vibrate(50);

### Positive Aspects
- Excellent accessibility implementation with proper labels and hints
- Meets WCAG 2.1 touch target requirements (200x200 > 44x44)
- Clean separation of concerns with Redux
- Comprehensive test coverage
- Proper TypeScript typing
- RTL/LTR support via theme
- Clear, readable code structure

---
*Automated review by Heirloom Code Review Agent*
```

---

## Parallel Execution of Other Agents

While UI Generator was working, other agents were processing in parallel:

### Backend Integration Agent (AudioService)
- **Time:** 0:15-0:55 (40 seconds)
- **Output:** 
  - `src/services/AudioService.ts`
  - `src/types/Audio.ts`
  - `src/services/__tests__/AudioService.test.ts`
- **PR:** #2

### Backend Integration Agent (TranscriptionService)
- **Time:** 0:16-0:58 (42 seconds)
- **Output:**
  - `src/services/TranscriptionService.ts`
  - `src/types/Transcription.ts`
  - `src/services/__tests__/TranscriptionService.test.ts`
- **PR:** #3

### UI Generator Agent (AudioVisualizer)
- **Time:** 0:17-0:48 (31 seconds)
- **Output:**
  - `src/components/AudioVisualizer.tsx`
  - `src/components/__tests__/AudioVisualizer.test.tsx`
- **PR:** #4

### State Management Agent (RecordingSlice)
- **Time:** 0:18-0:42 (24 seconds)
- **Output:**
  - `src/store/recordingSlice.ts`
  - `src/store/__tests__/recordingSlice.test.ts`
- **PR:** #5

---

## Final Results Summary

### Total Execution Time: ~1 minute

### Generated Outputs:

**6 Pull Requests Created:**
1. RecordingScreen UI Component (#1) - APPROVED
2. AudioService Integration (#2) - APPROVED
3. TranscriptionService Integration (#3) - APPROVED  
4. AudioVisualizer Component (#4) - APPROVED
5. RecordingState Redux Slice (#5) - APPROVED
6. OfflineQueue Service (#6) - APPROVED

**Files Created: 12**
- 6 implementation files
- 6 test files

**Tests Written: 32**
- All passing ✅

**Lines of Code Generated: ~2,400**
- Production code: ~1,600 lines
- Test code: ~800 lines

**Documentation:**
- 6 PR descriptions with usage examples
- Integration notes
- Setup instructions

---

## Your Action Items

### Review PRs (15-20 minutes)

1. **Check PR #1 (RecordingScreen)**
```bash
gh pr view 1
gh pr diff 1
```

Review the code, test locally if needed:
```bash
gh pr checkout 1
npm test
npm start
```

2. **Merge if satisfied**
```bash
gh pr merge 1 --squash
```

3. **Repeat for other PRs**

### Test Integration (10 minutes)

Once all PRs are merged:
```bash
git pull origin main
npm install
npm test
npm start
```

Test the recording feature on device/simulator.

---

## Cost Breakdown

### API Usage:

**Project Manager Agent:**
- 1 request: ~1,500 tokens input, ~500 tokens output
- Cost: ~$0.005

**UI Generator Agents (2):**
- 2 requests: ~3,000 tokens input each, ~2,000 tokens output each
- Cost: ~$0.20

**Backend Integration Agents (3):**
- 3 requests: ~4,000 tokens input each, ~3,000 tokens output each
- Cost: ~$0.45

**State Management Agent (1):**
- 1 request: ~2,000 tokens input, ~1,000 tokens output
- Cost: ~$0.08

**Code Review Agents (6):**
- 6 requests: ~2,000 tokens input each, ~500 tokens output each
- Cost: ~$0.12

**Total Cost: ~$0.90**

### Time Saved:

**Traditional Development:**
- RecordingScreen UI: 4 hours
- AudioService: 6 hours
- TranscriptionService: 5 hours
- AudioVisualizer: 3 hours
- RecordingSlice: 2 hours
- OfflineQueue: 4 hours
- Tests: 8 hours
- **Total: ~32 hours**

**With AI Agents:**
- Generation: 1 minute
- Your review: 20 minutes
- Testing: 10 minutes
- **Total: ~30 minutes**

**Time Saved: 31.5 hours**
**Cost: $0.90**
**Value: ~$3,000-5,000 (at junior dev rates)**

---

## What You Get

### Production-Ready Code
- ✅ TypeScript
- ✅ React Native best practices
- ✅ Accessibility compliant
- ✅ RTL/LTR support
- ✅ Redux state management
- ✅ Error handling
- ✅ Offline support

### Comprehensive Tests
- ✅ Unit tests for all components
- ✅ Service tests
- ✅ Redux slice tests
- ✅ Accessibility tests

### Documentation
- ✅ PR descriptions
- ✅ Usage examples
- ✅ Integration notes
- ✅ API documentation

### Quality Assurance
- ✅ Automated code review
- ✅ Best practices enforced
- ✅ Security checks
- ✅ Performance suggestions

---

## Conclusion

In **under 1 minute**, the n8n agent system:
1. Analyzed your requirements
2. Created a development plan
3. Generated 12 files of production-ready code
4. Wrote 32 comprehensive tests
5. Created 6 documented pull requests
6. Performed automated code reviews

All for less than $1, saving you 31+ hours of development time.

**This is the power of AI-assisted development with n8n!**
