# Contributing to Heirloom Documentation

**Purpose**: Prevent documentation sprawl and maintain a clean, maintainable documentation structure.

**Last Updated**: 2025-11-09

---

## 📋 Documentation Structure

We maintain **11 core documents** in the project root:

| Document | Purpose | When to Update |
|----------|---------|----------------|
| **PROJECT.md** | Project overview, vision, architecture | When project scope or architecture changes |
| **STATUS.md** | Current implementation status | When features are completed |
| **ROADMAP.md** | Future plans and enhancements | When planning new features |
| **REQUIREMENTS.md** | Technical requirements (FR/NFR) | When adding new requirements |
| **SETUP.md** | Installation and deployment | When setup process changes |
| **DEVELOPMENT.md** | Developer guide | When adding dev workflows |
| **CHANGELOG.md** | Recent changes | For every significant change |
| **BUGS.md** | Known issues and bugs | When bugs are discovered/fixed |
| **TESTING-GUIDE.md** | Manual testing procedures | When new features require testing |
| **TEST_PLAN.md** | Automated test strategy | When adding test coverage |
| **CONTRIBUTING.md** | This file | When governance rules change |

---

## ✅ UPDATE Existing Documents (Default Action)

**BEFORE creating ANY new markdown file, ask yourself:**

1. Does this belong in an existing document?
2. Is this a temporary update that should go in CHANGELOG.md?
3. Is this a bug that should go in BUGS.md?
4. Is this a feature plan that should go in ROADMAP.md?
5. Is this an implementation detail that belongs in code comments?

### Decision Tree

```
New information to document?
│
├─ Is it a bug or issue? → Update BUGS.md
├─ Is it a future feature? → Update ROADMAP.md
├─ Is it implemented? → Update STATUS.md + CHANGELOG.md
├─ Is it a requirement? → Update REQUIREMENTS.md
├─ Is it project info? → Update PROJECT.md
├─ Is it a setup change? → Update SETUP.md
├─ Is it a dev guide? → Update DEVELOPMENT.md
└─ Is it a daily update? → Update CHANGELOG.md
```

---

## 📝 Document Update Guidelines

### PROJECT.md
**Update when:**
- Project vision or goals change
- Architecture changes significantly
- Tech stack additions/removals
- Business model changes

**Don't update for:**
- Feature implementation details (use STATUS.md)
- Bug fixes (use BUGS.md)
- Temporary changes

### STATUS.md
**Update when:**
- Feature is completed and tested
- Major milestone reached
- Metrics change significantly (monthly update)

**Format:**
- Move completed items from ROADMAP.md to STATUS.md
- Add completion date
- Update progress percentages
- Add to CHANGELOG.md with details

### ROADMAP.md
**Update when:**
- Planning new feature
- Reprioritizing features
- Adding technical debt items
- External dependencies change (e.g., Play.ht deprecation)

**Don't include:**
- Features already implemented (use STATUS.md)
- Bugs (use BUGS.md)
- Detailed implementation steps (use code comments or issues)

### BUGS.md
**Update when:**
- New bug discovered
- Bug status changes (investigating → fix planned → fixed)
- Workaround found
- Bug resolved (keep for 1 month, then archive)

**Format:**
- Use priority sections (P0, P1, P2, P3)
- Include component, status, workaround
- Link to related docs and GitHub issues
- Archive resolved bugs after 1 month

### CHANGELOG.md
**Update for:**
- Every feature completion
- Every bug fix
- Configuration changes
- Deployment updates
- Breaking changes

**Format:**
```markdown
## [Date] - [Brief Description]

### Added
- Feature X with Y capability

### Changed
- Updated Z configuration

### Fixed
- Bug ABC in component XYZ

### Security
- Fixed security issue (if applicable)
```

---

## ❌ DO NOT Create New Documents For

### Never Create Files For These:

- ❌ **Bug reports** → Use BUGS.md
- ❌ **Feature plans** → Use ROADMAP.md
- ❌ **Status updates** → Use STATUS.md + CHANGELOG.md
- ❌ **Implementation notes** → Use code comments or GitHub issues
- ❌ **Quick fixes** → Use BUGS.md or CHANGELOG.md
- ❌ **Temporary documentation** → Use comments or issues
- ❌ **Meeting notes** → Use issue comments or project management tool
- ❌ **"FIX_" or "BUG_" files** → Use BUGS.md
- ❌ **"UPDATE_" or "CHANGES_" files** → Use CHANGELOG.md
- ❌ **Date-specific files** → Use CHANGELOG.md with dates

### Examples of What NOT to Do

❌ **Bad**: Create `FIX_VOICE_CLONE_TIMEOUT.md`
✅ **Good**: Add to BUGS.md under appropriate priority

❌ **Bad**: Create `VOICE_CLONING_PLAN_V3.md`
✅ **Good**: Update ROADMAP.md with voice cloning enhancements

❌ **Bad**: Create `UPDATE-2025-11-15.md`
✅ **Good**: Add entry to CHANGELOG.md for 2025-11-15

❌ **Bad**: Create `FR-99-NEW-FEATURE.md`
✅ **Good**: Add FR-99 to REQUIREMENTS.md, add plan to ROADMAP.md

---

## ✅ ONLY Create New Documents When

### Acceptable New Documents:

1. **Specialized Utility Guide** (permanent reference)
   - Example: `QUESTION_CSV_GUIDE.md`
   - Criteria:
     - Permanent workflow documentation
     - Too detailed/specific for DEVELOPMENT.md
     - Standalone utility or tool
     - >200 lines of content

2. **User-Facing Documentation** (in `docs/` folder)
   - Example: `docs/VOICE_CLONING_USER_GUIDE.md`
   - Criteria:
     - End-user documentation (not developer)
     - API documentation
     - Step-by-step tutorials
     - Place in `docs/` folder, NOT root

3. **Script Documentation** (in `scripts/` folder)
   - Example: `scripts/QUICKSTART.md`
   - Criteria:
     - Script-specific instructions
     - Place in `scripts/` folder with script
     - Link from DEVELOPMENT.md

4. **GitHub Templates** (in `.github/` folder)
   - Example: `.github/ISSUE_TEMPLATE/bug_report.md`
   - Criteria:
     - GitHub-specific templates
     - Must be in `.github/` folder

### Approval Process for New Documents

**Before creating a new document in root:**

1. **Justify**: Why can't this go in existing docs?
2. **Size**: Is it >200 lines? (If not, merge into existing doc)
3. **Permanence**: Will this be relevant in 6+ months?
4. **Uniqueness**: Is this content already covered elsewhere?

**Get approval from:**
- Team lead review
- Or: Document in CONTRIBUTING.md first

---

## 📂 Archiving Rules

### When to Archive

Move files to `Archive/` folder when:

1. **Feature is fully implemented and stable** (>3 months)
   - Example: Voice cloning plans after implementation complete

2. **Bug is fixed and verified** (>1 month)
   - Example: AI interview bug fixes after verification

3. **Document is historical reference only**
   - Example: Old implementation plans, outdated guides

### How to Archive

1. **Consolidate** related files into one archive document:
   ```
   VOICE_CLONING_IMPLEMENTATION_PLAN.md
   VOICE_CLONING_IMPLEMENTATION_PLAN_V2.md
   VOICE_CLONING_V2_ROADMAP.md

   → Archive/VOICE_CLONING_COMPLETE.md
   ```

2. **Add header** to archived document:
   ```markdown
   # [Feature Name] - ARCHIVED

   **Status**: ✅ Implemented and Stable
   **Completion Date**: YYYY-MM-DD
   **Current Status**: See STATUS.md
   **Related Code**: src/path/to/code.js

   ---

   [Original content...]
   ```

3. **Update references** in other documents to point to archive

4. **Remove from root** directory

---

## 🔍 Review Process

### Before Committing ANY .md File Changes

Run this checklist:

```bash
# 1. Check file count (should be ≤14 in root)
ls -1 *.md | wc -l

# 2. Check for duplicate headers (indicates content duplication)
grep -h "^# " *.md | sort | uniq -d

# 3. Check file sizes (large files may need splitting)
ls -lh *.md | awk '$5 > "50K" {print $9, $5}'

# 4. Check for date-specific files (should use CHANGELOG instead)
ls *202*.md 2>/dev/null

# 5. Check for "FIX" or "BUG" files (should use BUGS.md)
ls *FIX*.md *BUG*.md 2>/dev/null
```

### Pre-Commit Questions

- [ ] Did I update existing docs first?
- [ ] Is this new file absolutely necessary?
- [ ] Can this be merged into another doc?
- [ ] Is this temporary? (If yes, use CHANGELOG or BUGS)
- [ ] Will this be relevant in 6 months?
- [ ] Have I updated cross-references in other docs?

---

## 📅 Monthly Maintenance (First Monday)

**Monthly Documentation Cleanup Checklist:**

### Week 1 of Each Month:

- [ ] **CHANGELOG.md**: Consolidate entries older than 6 months into summary
- [ ] **BUGS.md**: Move resolved bugs >1 month old to archive
- [ ] **ROADMAP.md**: Remove completed features (move to STATUS.md)
- [ ] **STATUS.md**: Update metrics and progress percentages
- [ ] **Root cleanup**: Check for files >6 months old → Archive
- [ ] **File count**: Verify ≤12 files in root directory
- [ ] **Update dates**: Update "Last Updated" in all core docs

### Quarterly Review (Every 3 Months):

- [ ] Review all documents for accuracy
- [ ] Consolidate redundant content
- [ ] Update PROJECT.md with major changes
- [ ] Archive stable features from ROADMAP
- [ ] Update REQUIREMENTS.md with new FRs/NFRs

---

## 🔐 Security Documentation

### For Security Issues:

1. **Critical security issues**:
   - Report privately to team lead
   - Do NOT create public documentation
   - Use BUGS.md only after fix is deployed

2. **Security fixes**:
   - Document in BUGS.md under "Security Issues" section
   - Mark as resolved after verification
   - Document prevention measures

3. **Sensitive information**:
   - NEVER commit API keys, credentials, or secrets
   - Use `.env.example` for environment templates
   - Reference environment variables in docs

---

## 📊 Documentation Metrics

### Success Metrics:

- **File count**: ≤14 markdown files in root directory (11 core + 3 specialized)
- **File age**: 80% of docs updated within 6 months
- **Duplication**: Zero duplicate headers across docs
- **Archival rate**: Files archived within 1 month of completion

### Red Flags:

- 🚨 >17 files in root directory
- 🚨 Multiple files covering same topic
- 🚨 Date-specific filenames (e.g., UPDATE-2025-XX-XX.md)
- 🚨 "FIX" or "BUG" files in root
- 🚨 Files unchanged for >12 months (should be archived or deleted)

---

## 🎯 Examples of Good vs Bad Documentation

### ✅ Good Example: Discovering a Bug

```markdown
1. Open BUGS.md
2. Add under appropriate priority:

### Bug: Audio Upload Fails on Safari
- **Component**: Audio Recorder
- **Status**: Investigating
- **Reported**: 2025-11-04
- **Description**: WebM format not supported on Safari
- **Workaround**: Use Chrome or Firefox
- **Fix Plan**: Convert to MP3 format server-side
- **Related Code**: src/AudioRecorder.jsx:590

3. Update CHANGELOG.md:
## 2025-11-04
### Fixed
- Investigating audio upload issue on Safari (BUGS.md)

4. Commit both files
```

❌ **Bad**: Create `FIX_SAFARI_AUDIO_BUG.md`

### ✅ Good Example: Planning a New Feature

```markdown
1. Open ROADMAP.md
2. Add under appropriate phase:

### Phase X: DialogFlow CX Integration
**Priority**: High
**Timeline**: Q1 2026
**Status**: Planned

**Goal**: Replace custom conversation logic with DialogFlow CX

**Benefits**:
- Eliminates progression bugs
- Better conversation management
- Native multi-language support

**Implementation**: See docs/dialogflow-cx-integration.md (when created)

3. Update CHANGELOG.md:
## 2025-11-04
### Planned
- Added DialogFlow CX integration to ROADMAP.md (Phase X)

4. Commit both files
```

❌ **Bad**: Create `DIALOGFLOW_PLAN.md` or `DIALOGFLOW_IMPLEMENTATION.md`

### ✅ Good Example: Completing a Feature

```markdown
1. Open STATUS.md, add:
### Voice Cloning (FR-46)
- ✅ **Status**: Implemented and Stable
- **Completion Date**: 2025-11-03
- **Details**: Multi-provider support (ElevenLabs, Play.ht alternatives)
- **Code**: src/services/voiceCloneService.js
- **Docs**: docs/VOICE_CLONING_USER_GUIDE.md

2. Open ROADMAP.md, remove voice cloning section

3. Open CHANGELOG.md, add:
## 2025-11-03
### Added
- Voice cloning with multi-provider support (FR-46)
- Real-time job status tracking
- Async job queue to prevent timeouts

4. Archive old planning docs:
mv VOICE_CLONING_*.md Archive/VOICE_CLONING_COMPLETE.md

5. Commit all changes
```

❌ **Bad**: Keep multiple VOICE_CLONING_*.md files in root

---

## 🤝 Getting Help

**Questions about documentation?**

1. Check this CONTRIBUTING.md file first
2. Search existing docs for similar content
3. Ask: "Can this go in an existing file?"
4. When in doubt, update existing docs

**Need to break these rules?**

Document the exception here and explain why.

---

## 📖 Quick Reference

**Quick command to check documentation health:**

```bash
# Run this before committing docs
./scripts/check-docs.sh  # (TODO: Create this script)

# Manual checks:
ls -1 *.md | wc -l  # Should be ≤14
git diff --name-only '*.md'  # See what changed
```

---

**Remember**: The best documentation is updated documentation. Keep it clean, keep it current, keep it consolidated.
