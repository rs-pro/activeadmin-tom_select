# ActiveAdmin 4 Migration Guide for Gem Maintainers

## Overview

This document provides a comprehensive guide for gem maintainers on how to update their gems to support ActiveAdmin 4, based on the changes made to the `activeadmin-searchable_select` gem. The migration involved addressing significant changes in asset handling, JavaScript module systems, dependency management, and CSS selectors.

## Key Migration Steps

### 1. Update Dependency Constraints

#### Ruby Version Requirements
- **Minimum Ruby version**: 3.2 (Ruby 3.0 and 3.1 are dropped in ActiveAdmin 4)
- Update your gemspec: `spec.required_ruby_version = '>= 3.2'`

#### Rails Version Requirements
- **Minimum Rails version**: 7.0 (Rails 6.1 support dropped)
- ActiveAdmin 4 supports Rails 7.x and 8.x

#### ActiveAdmin Version
```ruby
# In gemspec
spec.add_runtime_dependency 'activeadmin', ['>= 1.x', '< 5']
```

### 2. Asset Pipeline Migration

ActiveAdmin 4 moved away from the traditional Rails asset pipeline to modern JavaScript bundlers.

#### Key Changes:
- ActiveAdmin 4 assumes `cssbundling-rails` and `importmap-rails` are installed
- No longer uses `register_stylesheet` or `register_javascript` methods
- Requires explicit JavaScript module initialization

#### JavaScript Module Support

Create multiple module formats to support different bundlers:

1. **ESM Module** (`searchable_select.esm.js`):
```javascript
import $ from 'jquery';
import select2 from 'select2';

// Critical: Initialize select2 on jQuery for production builds
select2($);

// Ensure jQuery is globally available
window.$ = window.jQuery = $;

// Your initialization code here
```

2. **Traditional Module** (for backward compatibility)
3. **CDN-compatible version** (for importmap users)

### 3. Installation Generator

Create a generator to help users set up your gem with different bundlers:

```ruby
module YourGem
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :bundler,
                   type: :string,
                   default: 'esbuild',
                   enum: %w[esbuild importmap webpack]

      def setup_javascript
        case options[:bundler]
        when 'esbuild'
          setup_esbuild
        when 'importmap'
          setup_importmap
        when 'webpack'
          setup_webpack
        end
      end
      
      private
      
      def setup_esbuild
        # Add imports to app/javascript/active_admin.js
        append_to_file 'app/javascript/active_admin.js' do
          <<~JS
            import $ from 'jquery';
            import yourPlugin from 'your-plugin';
            
            // Initialize plugin on jQuery
            yourPlugin($);
            window.$ = window.jQuery = $;
            
            import '@your-scope/your-gem';
          JS
        end
      end
      
      def setup_importmap
        # Add pins to config/importmap.rb
        append_to_file 'config/importmap.rb' do
          <<~RUBY
            pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"
            pin "your-plugin", to: "https://cdn.jsdelivr.net/npm/your-plugin/dist/plugin.min.js"
            pin "your-gem", to: "your-gem.js"
          RUBY
        end
      end
    end
  end
end
```

### 4. NPM Package Publishing

If your gem includes JavaScript, consider publishing an NPM package:

#### Package.json Configuration
```json
{
  "name": "@your-scope/your-gem",
  "version": "1.0.0",
  "main": "src/index.js",
  "module": "src/index.js",
  "exports": {
    ".": {
      "import": "./src/index.js",
      "require": "./src/index.js",
      "default": "./src/index.js"
    },
    "./css": "./src/styles.scss"
  },
  "peerDependencies": {
    "jquery": ">= 3.0, < 5"
  },
  "files": [
    "src/**/*",
    "vendor/assets/**/*"
  ],
  "scripts": {
    "prepublishOnly": "npm run prepare_sources"
  }
}
```

### 5. CSS Selector Updates

ActiveAdmin 4 introduced several CSS class changes:

| ActiveAdmin 3.x | ActiveAdmin 4.x |
|----------------|-----------------|
| `.filter_form` | `.filters-form` |
| `.tabs` component | Removed - use divs with Tailwind |
| `.columns` component | Replaced with Tailwind grid |

Update your JavaScript and CSS accordingly:
```javascript
// Old
$('.filter_form select').select2();

// New
$('.filters-form select').select2();
```

### 6. Testing Updates

#### Test Environment Setup
```ruby
# spec/rails_helper.rb or test_helper.rb
RSpec.configure do |config|
  config.before(:each, type: :feature) do
    # ActiveAdmin 4 requires explicit asset loading in tests
    ActiveAdmin.application.stylesheets.clear
    ActiveAdmin.application.javascripts.clear
  end
end
```

#### Capybara Configuration
```ruby
# For Playwright driver (recommended for JavaScript testing)
Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(
    app,
    browser_type: :chromium,
    headless: true
  )
end

Capybara.default_driver = :playwright
Capybara.javascript_driver = :playwright
```

### 7. Production Build Issues

Common production issues and solutions:

#### Issue: JavaScript plugin not initialized
**Solution**: Explicitly initialize jQuery plugins
```javascript
import select2 from 'select2';
import $ from 'jquery';

// This is critical for production builds
select2($);
```

#### Issue: jQuery not globally available
**Solution**: Ensure global assignment
```javascript
window.$ = window.jQuery = $;
```

#### Issue: Assets not loading in production
**Solution**: Use CDN fallbacks or vendor assets
```ruby
# In your gem's engine.rb
class Engine < ::Rails::Engine
  initializer 'your_gem.assets' do |app|
    if Rails.env.production?
      # Add fallback assets
    end
  end
end
```

### 8. CI/CD Updates

Update your GitHub Actions workflow:

```yaml
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        ruby: ['3.2', '3.3']
        rails: ['7.0', '7.1', '7.2', '8.0']
        activeadmin: ['4.0.0.beta16']
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Ruby
        uses: ruby/setup-ruby@v1
        with:
          ruby-version: ${{ matrix.ruby }}
          bundler-cache: true
      
      - name: Install Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install npm dependencies
        run: npm install
      
      - name: Install Playwright browsers
        run: npx playwright install chromium
      
      - name: Run tests
        run: bundle exec rspec
```

### 9. Appraisals Configuration

Use Appraisal gem to test against multiple versions:

```ruby
# Appraisals file
appraise 'rails-7.x-active-admin-4.x' do
  gem 'rails', '~> 7.0'
  gem 'activeadmin', '~> 4.0.0.beta16'
  gem 'sassc-rails'
  gem 'sprockets', '~> 4.0'
end

appraise 'rails-8.x-active-admin-4.x' do
  gem 'rails', '~> 8.0'
  gem 'activeadmin', '~> 4.0.0.beta16'
  gem 'sassc-rails'
  gem 'propshaft'
end
```

### 10. Common Pitfalls and Solutions

#### Pitfall 1: Select2 or similar jQuery plugins not working
**Root Cause**: Plugin not attached to jQuery object in production
**Solution**: Explicitly call `plugin($)` after importing

#### Pitfall 2: CSS classes not found
**Root Cause**: ActiveAdmin 4 changed many CSS selectors
**Solution**: Search and replace old selectors with new ones

#### Pitfall 3: Tests passing locally but failing in CI
**Root Cause**: Missing JavaScript dependencies or browser drivers
**Solution**: Install Playwright or proper WebDriver, ensure npm packages are installed

#### Pitfall 4: Assets not compiling in production
**Root Cause**: Missing bundler configuration
**Solution**: Provide clear setup instructions for each bundler type

## Migration Checklist

- [ ] Update Ruby version requirement to >= 3.2
- [ ] Update Rails version requirement to >= 7.0
- [ ] Update ActiveAdmin dependency to support 4.x
- [ ] Create ESM JavaScript modules
- [ ] Add installation generator for different bundlers
- [ ] Publish NPM package (if applicable)
- [ ] Update CSS selectors (`.filter_form` → `.filters-form`)
- [ ] Fix jQuery plugin initialization for production
- [ ] Update test suite for new asset handling
- [ ] Configure CI for multiple version testing
- [ ] Update documentation with setup instructions
- [ ] Test with esbuild, webpack, and importmap
- [ ] Add CDN fallbacks for JavaScript dependencies
- [ ] Handle both Sprockets and Propshaft

## Example Implementation

See the full implementation in the `activeadmin-searchable_select` gem:
- [Installation Generator](../lib/generators/active_admin/searchable_select/install/install_generator.rb)
- [ESM Module](../app/assets/javascripts/active_admin/searchable_select.esm.js)
- [Package.json](../package.json)
- [CI Configuration](../.github/workflows/ci.yml)

## Resources

- [ActiveAdmin 4.0 Breaking Changes](./activeadmin-4-changes.md)
- [ActiveAdmin 4.0 Release Notes](https://github.com/activeadmin/activeadmin/releases)
- [Rails 7+ Asset Pipeline Guide](https://guides.rubyonrails.org/asset_pipeline.html)
- [esbuild Rails Documentation](https://github.com/rails/jsbundling-rails)
- [Importmap Rails Documentation](https://github.com/rails/importmap-rails)

## Conclusion

Migrating a gem to support ActiveAdmin 4 requires careful attention to:
1. Modern JavaScript module systems
2. Flexible asset pipeline support
3. Updated CSS selectors and components
4. Proper jQuery plugin initialization
5. Comprehensive testing across different setups

The key to success is providing multiple paths for users with different asset pipeline configurations while maintaining backward compatibility where possible.