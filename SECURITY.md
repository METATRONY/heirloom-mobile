# Security Guidelines for N8N Agents

This document outlines security best practices for implementing n8n agents in the Heirloom development system.

## Critical Security Principles

### 1. Input Validation

**✅ DO:**
- Validate all webhook inputs using regex patterns
- Use allowlists for acceptable values
- Check for path traversal attempts (`..`)
- Validate repository names and owner names
- Use TypeScript/JavaScript validation in Code nodes

**❌ DON'T:**
- Accept arbitrary input without validation
- Trust user-provided paths directly
- Skip validation for "internal" workflows

### 2. Command Injection Prevention

**✅ DO:**
- Use Code nodes with Node.js APIs instead of `executeCommand`
- Use parameterized commands when shell execution is necessary
- Sanitize all inputs that go into shell commands
- Use `child_process.execFile()` with array arguments
- Validate file paths against allowlists

**❌ DON'T:**
- Use `executeCommand` with string interpolation
- Concatenate user input into shell commands
- Trust AI-generated content in shell commands
- Use `eval()` or similar dynamic code execution

**Example - Insecure:**
```javascript
{
  "command": "=echo '{{ $json.user_input }}' > file.txt"
}
```

**Example - Secure:**
```javascript
{
  "mode": "runOnceForEachItem",
  "jsCode": `
    const fs = require('fs');
    const path = require('path');
    
    const userInput = $input.item.json.user_input || '';
    const sanitized = userInput.replace(/[<>]/g, '');
    
    const filePath = path.join('/safe/directory', 'file.txt');
    fs.writeFileSync(filePath, sanitized, 'utf8');
    
    return { json: { written: true } };
  `
}
```

### 3. Path Traversal Prevention

**✅ DO:**
- Use `path.join()` to construct file paths
- Validate paths don't contain `..`
- Check paths are within allowed directories
- Use absolute paths from environment variables
- Maintain an allowlist of writable directories

**❌ DON'T:**
- Accept raw file paths from users
- Trust AI-generated file paths
- Allow writes outside project directory
- Use relative paths without validation

**Example - Secure Path Validation:**
```javascript
const path = require('path');

function isPathSafe(filePath, projectRoot, allowedDirs) {
  // Resolve to absolute path
  const absolute = path.resolve(projectRoot, filePath);
  
  // Check it's within project root
  if (!absolute.startsWith(projectRoot)) {
    return false;
  }
  
  // Check it's in an allowed directory
  const relative = path.relative(projectRoot, absolute);
  const isAllowed = allowedDirs.some(dir => 
    relative.startsWith(dir) && !relative.includes('..')
  );
  
  return isAllowed;
}

// Usage
const allowed = ['src/components', 'src/screens', 'src/locales'];
if (!isPathSafe(userPath, projectRoot, allowed)) {
  throw new Error('Invalid file path');
}
```

### 4. Environment Variables

**✅ DO:**
- Use environment variables for project paths
- Store credentials in n8n credential system
- Use `$env` variables in workflows
- Document required environment variables

**❌ DON'T:**
- Hardcode paths like `/path/to/project`
- Store credentials in workflow JSON
- Commit sensitive data to repository

**Example Configuration:**
```javascript
{
  "project_path": "={{ $env.PROJECT_PATH || '/workspace/project' }}",
  "github_token": "={{$credentials.githubApi.token}}"
}
```

### 5. Error Handling and Rollback

**✅ DO:**
- Add error outputs to all critical nodes
- Implement rollback mechanisms
- Use try-catch in Code nodes
- Log errors without exposing sensitive data
- Clean up on failure

**❌ DON'T:**
- Silently ignore errors
- Leave partial changes on failure
- Expose stack traces to users
- Continue after critical failures

**Example - Error Handling:**
```javascript
{
  "mode": "runOnceForEachItem",
  "jsCode": `
    try {
      const fs = require('fs');
      // ... do work ...
      return { json: { success: true } };
    } catch (error) {
      // Clean up
      try {
        // Rollback changes
      } catch (rollbackError) {
        console.error('Rollback failed:', rollbackError.message);
      }
      
      throw new Error(\`Operation failed: \${error.message}\`);
    }
  `
}
```

### 6. AI Response Validation

**✅ DO:**
- Validate JSON structure from Claude/GPT
- Check all required fields exist
- Sanitize strings before using them
- Validate file paths from AI
- Limit array sizes
- Set maximum iteration counts

**❌ DON'T:**
- Trust AI output blindly
- Use AI-generated code without review
- Allow unbounded loops based on AI data
- Skip schema validation

**Example - AI Response Validation:**
```javascript
function validateTranslationData(data) {
  // Check structure
  if (!data.translations || !data.translations.en || !data.translations.he) {
    throw new Error('Invalid translation structure');
  }
  
  // Validate arrays
  if (!Array.isArray(data.rtl_fixes)) {
    data.rtl_fixes = [];
  }
  
  if (!Array.isArray(data.updated_files)) {
    data.updated_files = [];
  }
  
  // Limit size
  const MAX_FILES = 50;
  data.updated_files = data.updated_files.slice(0, MAX_FILES);
  
  // Validate paths
  data.updated_files = data.updated_files.filter(f => {
    return f.path && 
           f.path.startsWith('src/') && 
           !f.path.includes('..');
  });
  
  // Sanitize strings
  Object.keys(data.translations.en).forEach(key => {
    data.translations.en[key] = sanitizeString(data.translations.en[key]);
  });
  
  return data;
}
```

### 7. Rate Limiting and Resource Management

**✅ DO:**
- Set timeouts on HTTP requests
- Implement retry logic with backoff
- Limit concurrent operations
- Monitor API usage
- Set maximum file sizes

**❌ DON'T:**
- Make unbounded API calls
- Process unlimited data
- Allow infinite loops
- Skip timeout configuration

**Example - HTTP with Retry:**
```javascript
{
  "options": {
    "timeout": 60000,
    "retry": {
      "enabled": true,
      "maxTries": 3,
      "waitBetweenTries": 1000
    }
  }
}
```

### 8. Git Operations Security

**✅ DO:**
- Validate branch names
- Sanitize commit messages
- Use `execSync` with `cwd` option
- Implement atomic operations
- Clean up on failure

**❌ DON'T:**
- Trust user-provided branch names
- Allow injection in commit messages
- Use force push
- Leave repos in inconsistent state

**Example - Secure Git Operations:**
```javascript
const { execSync } = require('child_process');
const path = require('path');

const projectPath = $input.item.json.project_path;
if (!projectPath || projectPath.includes('..')) {
  throw new Error('Invalid project path');
}

// Sanitize branch name
const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
const branchName = `feature/safe-name-${timestamp}`;

// Sanitize commit message
const message = $input.item.json.message || 'Update files';
const safeMessage = message.replace(/["'\\]/g, '');

try {
  execSync(`git checkout -b ${branchName}`, { cwd: projectPath });
  execSync('git add .', { cwd: projectPath });
  execSync(`git commit -m "${safeMessage}"`, { cwd: projectPath });
  execSync(`git push -u origin ${branchName}`, { cwd: projectPath });
} catch (error) {
  // Rollback
  try {
    execSync('git reset --hard HEAD', { cwd: projectPath });
  } catch (rollbackError) {
    console.error('Rollback failed');
  }
  throw error;
}
```

## Security Checklist for New Agents

Before deploying a new agent, verify:

- [ ] All webhook inputs are validated
- [ ] No `executeCommand` nodes with user input
- [ ] All file paths validated and sanitized
- [ ] Environment variables used for configuration
- [ ] Error handling implemented on all nodes
- [ ] Rollback mechanism in place
- [ ] AI responses validated and sanitized
- [ ] Rate limiting configured
- [ ] Git operations secured
- [ ] No hardcoded paths or credentials
- [ ] Maximum iteration limits set
- [ ] Timeout configured on HTTP requests
- [ ] Retry logic implemented
- [ ] Documentation includes security notes

## Testing Security

### Manual Security Testing

1. **Test with malicious input:**
   ```json
   {
     "path": "../../../etc/passwd",
     "github_repo": "'; rm -rf / #",
     "content": "<script>alert('xss')</script>"
   }
   ```

2. **Test path traversal:**
   ```json
   {
     "file_path": "../../../../sensitive/file.txt"
   }
   ```

3. **Test command injection:**
   ```json
   {
     "message": "test'; cat /etc/passwd #"
   }
   ```

### Automated Security Testing

Create test cases that verify:
- Invalid paths are rejected
- Special characters are sanitized
- Commands with injection attempts fail safely
- Error handling works correctly
- Rollback mechanisms activate

## Incident Response

If a security issue is discovered:

1. **Immediately disable the affected workflow**
2. **Assess the impact:**
   - What data was exposed?
   - What systems were affected?
   - How many users impacted?

3. **Fix the vulnerability:**
   - Apply the fix
   - Test thoroughly
   - Review similar code

4. **Document the incident:**
   - What happened
   - How it was fixed
   - Lessons learned

5. **Update this document** with new guidelines

## Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [n8n Security Best Practices](https://docs.n8n.io/hosting/security/)
- [Node.js Security Checklist](https://cheatsheetseries.owasp.org/cheatsheets/Nodejs_Security_Cheat_Sheet.html)

## Contact

For security concerns or to report vulnerabilities:
- Open a private security advisory on GitHub
- Tag `@METATRONY` for review

---

**Last Updated:** 2025-11-19  
**Version:** 1.0  
**Status:** Active

