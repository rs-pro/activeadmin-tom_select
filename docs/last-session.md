# CI Fix Session - Playwright Version Mismatch

## Problem

CI was failing with `Executable doesn't exist at .../chromium_headless_shell-1223/...` because the npm `playwright` package version and the `playwright-ruby-client` gem version were out of sync.

### Root Cause

- `npm playwright` was pinned to `1.58.0` → downloads browsers at revision 1208
- `playwright-ruby-client` gem resolved to `1.58.1` (main Gemfile.lock) or `1.58.0` (appraisal lockfiles) → expected revision 1223
- Even when appraisal lockfiles showed `1.58.0`, the `ruby/setup-ruby@v1` action's `bundler-cache` likely cached `1.58.1` from the main Gemfile.lock, causing the mismatch at runtime

### Fix Applied

Aligned all versions to `1.60.0` (latest stable):

| File | Before | After |
|------|--------|-------|
| `spec/internal/package.json` | `"playwright": "1.58.0"` | `"playwright": "1.60.0"` |
| `spec/internal/package-lock.json` | `1.58.0` | `1.60.0` |
| `Gemfile.lock` (root) | `playwright-ruby-client 1.58.1` | `playwright-ruby-client 1.60.0` |
| All appraisal `*.gemfile.lock` | `playwright-ruby-client 1.58.0` | `playwright-ruby-client 1.60.0` |

### Other Completed Tasks

- Published `activeadmin-tom_select@4.2.0-beta3` to npm under both names:
  - `activeadmin-tom_select` (unscoped)
  - `@rocket-sensei/activeadmin-tom_select` (scoped)
  - Published with tag `beta` (prerelease)
- Created and pushed git tag `v4.2.0.beta3`

### Next Steps

1. Run `bundle exec rspec` to verify tests pass with aligned Playwright versions
2. If tests pass, commit remaining changes and push
3. Merge to master to trigger CI verification
4. Consider adding CI step to explicitly match `playwright-ruby-client` and npm `playwright` versions to prevent future drift
