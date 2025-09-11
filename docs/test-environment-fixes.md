# Test Environment Fixes for Tom Select Migration

## Issue
After migrating from Select2 to Tom Select, tests were failing because Propshaft wasn't being loaded in the test environment, causing assets not to be served properly.

## Root Cause
The Rails 8 test application wasn't loading Propshaft's railtie, which meant:
- No asset paths were configured
- Assets were being requested at wrong URLs (`/javascripts/` instead of `/assets/`)
- Tom Select JavaScript wasn't being loaded
- Tom Select wasn't initializing on searchable select inputs

## Solution

### 1. Load Propshaft Railtie
Added to `spec/internal/config/application.rb`:
```ruby
# Require Propshaft railtie for asset pipeline
require 'propshaft/railtie'
```

This ensures Propshaft is properly initialized with:
- Asset paths configured
- Dynamic resolver for test environment
- Proper asset serving with digest URLs

### 2. Key Configuration Details
After the fix, Propshaft in test environment has:
- **Asset paths**: 7 configured paths including app/assets/builds
- **Resolver**: `Propshaft::Resolver::Dynamic` (no precompilation needed)
- **Asset serving**: Enabled (`config.assets.server = true`)
- **URLs**: Proper digest URLs like `/assets/active_admin-f967af7b.js`

### 3. Test Adjustments
Minor adjustments to tests for Tom Select compatibility:
- Use `visible: :all` for finding dropdown options (Tom Select may create hidden options)
- More flexible selectors for Tom Select wrappers
- Removed hardcoded waits in favor of proper Capybara waiting

## Verification
Created comprehensive diagnostic test (`spec/features/asset_pipeline_diagnostic_spec.rb`) that verifies:
- Rails and Propshaft configuration
- Asset paths and files
- Built asset contents (checks for Tom Select code)
- Asset serving in browser
- JavaScript loading and initialization

## Results
- ✅ All production_build_spec tests passing
- ✅ Tom Select properly initializing
- ✅ Assets served with correct digest URLs
- ⚠️ Some end_to_end tests still need adjustment for Tom Select behavior differences

## Lessons Learned
1. Always verify that required railties are loaded in test environments
2. Use diagnostic tests to troubleshoot asset pipeline issues
3. Tom Select has slightly different DOM structure and behavior than Select2
4. Propshaft requires explicit railtie loading unlike Sprockets which was auto-loaded