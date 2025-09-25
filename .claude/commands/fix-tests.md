# Fix Tests - ActiveAdmin Searchable Select

## Overview
This guide provides instructions for debugging and fixing failing tests in the ActiveAdmin Searchable Select gem, particularly issues related to Select2 initialization and DOM element selection.

## Common Test Failures

### 1. Select2 Container Not Found
**Error:** `Unable to find css ".select2-container"`

**Root Causes:**
- JavaScript dependencies (jQuery, Select2) not loaded in test environment
- ActiveAdmin 4 expects `importmap-rails` but test environment uses no-op shims

**Solution:**
Check `/spec/internal/config/initializers/active_admin.rb` and ensure JavaScript dependencies are properly loaded:

```ruby
# Replace no-op javascript_importmap_tags with working implementation
config.register_javascript do
  raw <<~HTML
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script type="text/javascript">
      #{File.read(Rails.root.join('../../app/assets/javascripts/active_admin/searchable_select/init.js'))}
    </script>
  HTML
end
```

### 2. Filter Form Selector Changes
**Error:** `Unable to find css ".filter_form"`

**Root Cause:** ActiveAdmin 4 changed the filter form class from `.filter_form` to `.filters-form` (with an 's')

**Solution:** Update selectors in tests:
```ruby
# Old (incorrect)
within '.filter_form' do
  find('.select2-container').click
end

# New (correct)
within '.filters-form' do
  find('.select2-container').click
end
```

## Debugging Workflow

### Step 1: Add HTML Debug Output
When a test fails due to missing elements, add debug output to see the actual page structure:

```ruby
it 'your test' do
  visit '/admin/posts'
  
  # Debug: output page HTML
  puts "\n=== DEBUG: Page HTML ==="
  puts page.html
  puts "=== END DEBUG ===\n"
  
  # Debug: check for specific elements
  puts "Select2 containers found: #{page.all('.select2-container').count}"
  puts "Searchable select inputs: #{page.all('.searchable-select-input').count}"
  
  # Your test code here
end
```

### Step 2: Check JavaScript Loading
Add JavaScript debugging to verify dependencies are loaded:

```ruby
it 'checks JavaScript dependencies' do
  visit '/admin/posts'
  
  # Check if jQuery is loaded
  jquery_loaded = page.evaluate_script('typeof jQuery !== "undefined"')
  puts "jQuery loaded: #{jquery_loaded}"
  
  # Check jQuery version
  if jquery_loaded
    jquery_version = page.evaluate_script('jQuery.fn.jquery')
    puts "jQuery version: #{jquery_version}"
  end
  
  # Check if Select2 is loaded
  select2_loaded = page.evaluate_script('typeof jQuery !== "undefined" && jQuery.fn.select2 !== undefined')
  puts "Select2 loaded: #{select2_loaded}"
end
```

### Step 3: Capture Console Errors
For JavaScript-capable drivers, capture console errors:

```ruby
# Add to test setup
page.driver.browser.manage.logs.get(:browser).each do |log|
  puts "Console #{log.level}: #{log.message}"
end
```

### Step 4: Wait for Dynamic Elements
Ensure elements have time to initialize:

```ruby
# Use Capybara's wait functionality
expect(page).to have_css('.select2-container', wait: 5)

# Or wait for specific conditions
Capybara.using_wait_time(5) do
  find('.select2-container').click
end
```

## Project-Specific Considerations

### 1. Test Environment Setup
The test suite uses Combustion to create a minimal Rails app in `spec/internal/`. Key files:
- `spec/internal/config/initializers/active_admin.rb` - ActiveAdmin configuration
- `spec/internal/app/admin/` - Test admin resources
- `spec/internal/app/models/` - Test models

### 2. ActiveAdmin Version Compatibility
This gem supports multiple ActiveAdmin versions through Appraisal. Test against specific versions:
```bash
# Install appraisals
appraisal install

# Run tests against specific version
appraisal activeadmin-4 rspec
```

### 3. JavaScript Asset Loading
The gem's JavaScript is in `app/assets/javascripts/active_admin/searchable_select/`. In tests, ensure these files are loaded either:
- Via CDN (for simplicity in tests)
- Via Rails asset pipeline (for integration testing)
- Inline in the test initializer (current approach)

### 4. Inline AJAX Options Mode
For testing without real AJAX calls, enable inline mode:
```ruby
ActiveAdmin::TomSelect.inline_ajax_options = true
```
This renders all options statically in the HTML.

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/features/end_to_end_spec.rb

# Run specific test by line number
bundle exec rspec spec/features/production_build_spec.rb:56

# Run with documentation format for clarity
bundle exec rspec --format documentation

# Run tests matching a pattern
bundle exec rspec -e "searchable select"
```

## Common Fixes Checklist

1. ✅ Verify jQuery is loaded (version 3.x recommended)
2. ✅ Verify Select2 is loaded (version 4.1.0-rc.0)
3. ✅ Check CSS selectors match current ActiveAdmin version
4. ✅ Ensure test database has seed data if needed
5. ✅ Check for JavaScript console errors
6. ✅ Verify AJAX endpoints are defined (`searchable_select_options` in resource)
7. ✅ Wait for dynamic elements to initialize
8. ✅ Use correct Capybara driver for JavaScript tests (`:selenium_chrome_headless`)

## Troubleshooting Tips

1. **"Warning: method `all_options` already defined"** - Normal warning, can be ignored
2. **Flaky tests** - Add explicit waits or use `have_css` with wait parameter
3. **Different behavior in CI** - Check for timing issues, add debug output
4. **Select2 not initializing** - Verify document ready events are firing correctly

## Quick Debug Template

Add this to any failing test for comprehensive debugging:

```ruby
# Debug template
puts "\n=== DEBUG START ==="
puts "Current URL: #{current_url}"
puts "Page title: #{page.title}"
puts "Select2 containers: #{page.all('.select2-container').count}"
puts "Searchable inputs: #{page.all('.searchable-select-input').count}"
puts "jQuery loaded: #{page.evaluate_script('typeof jQuery !== "undefined"')}"
puts "Select2 loaded: #{page.evaluate_script('typeof jQuery !== "undefined" && jQuery.fn.select2 !== undefined')}"
save_screenshot('debug_screenshot.png') if respond_to?(:save_screenshot)
puts "=== DEBUG END ===\n"
```

This guide should help quickly diagnose and fix test failures related to the searchable select functionality.