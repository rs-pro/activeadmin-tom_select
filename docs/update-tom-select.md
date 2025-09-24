# Tom Select Migration Guide for ActiveAdmin 4

## Overview
This guide documents the complete migration from ActiveAdmin Searchable Select (Select2-based) to Tom Select (vanilla JS, no jQuery) with Tailwind CSS 4 support.

## Key Benefits of Migration

1. **No jQuery Dependency**: Tom Select is pure vanilla JavaScript, reducing bundle size
2. **Modern JavaScript**: ES6+ modules, better performance
3. **ActiveAdmin 4 Compatible**: Full support for latest ActiveAdmin
4. **Smaller Bundle**: Removed jQuery and Select2 dependencies

## Installation Steps

### 1. Update Gemfile

```ruby
# Remove old gem
# gem 'rs-activeadmin-searchable_select', github: 'glebtv/activeadmin-searchable_select'

# Add new gem (from RubyGems)
gem 'activeadmin-tom_select'
```

### 2. Update package.json

```json
{
  "dependencies": {
    // Remove these:
    // "jquery": "^3.7.1",
    // "select2": "^4.1.0-rc.0",
    // "@rocket-sensei/activeadmin-searchable_select": "^4.0.1",

    // Add these:
    "tom-select": "^2.4.3",
    "activeadmin-tom_select": "^4.1.0"
  }
}
```

### 3. Update JavaScript (app/js/active_admin.js)

```javascript
// Import ActiveAdmin core first - includes all features and Rails UJS
import "@activeadmin/activeadmin";

// Import Tom Select
import TomSelect from 'tom-select';
window.TomSelect = TomSelect;

// Import and setup ActiveAdmin Tom Select
import { setupAutoInit, initSearchableSelects } from 'activeadmin-tom_select';
window.initSearchableSelects = initSearchableSelects;
setupAutoInit();

console.log('ActiveAdmin loaded with Tom Select');
```

**Important**: Do NOT include jQuery - it's no longer needed!

### 4. Configure CSS (app/assets/stylesheets/active_admin.tailwind.css)

**CRITICAL**: Use Tailwind's @import syntax instead of @tailwind directives when importing vendor CSS:

```css
/* Use @import syntax for proper processing order */
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

/* Import vendor CSS */
@import 'tom-select/dist/css/tom-select.css';
@import 'activeadmin-tom_select/src/tom-select-tailwind.css';

/* Your custom styles here */
```

**Why @import instead of @tailwind?**
- Tailwind only processes imports at the top of the file
- Using @tailwind directives with vendor CSS imports can cause processing issues
- The @import syntax ensures proper CSS cascade order

### 5. Update Build Configuration

#### esbuild.config.js
```javascript
#!/usr/bin/env node
const esbuild = require('esbuild');
const path = require('path');

const config = {
  entryPoints: [
    'app/js/active_admin.js'
  ],
  bundle: true,
  sourcemap: true,
  format: 'esm',
  outdir: 'app/assets/builds',
  publicPath: '/assets',
  loader: {
    '.js': 'js',
    '.jsx': 'jsx',
  },
  define: {
    'global': 'window'
  }
};

// Build logic here...
```

#### tailwind-active_admin.config.js
```javascript
const execSync = require("node:child_process").execSync;
const activeAdminPlugin = require('@activeadmin/activeadmin/plugin');

const activeAdminPath = execSync("bundle show activeadmin", {
  encoding: "utf-8",
}).trim();

module.exports = {
  content: [
    `${activeAdminPath}/vendor/javascript/flowbite.js`,
    `${activeAdminPath}/plugin.js`,
    `${activeAdminPath}/app/views/**/*.{arb,erb,html,rb}`,
    "./app/admin/**/*.{arb,erb,html,rb}",
    "./app/views/active_admin/**/*.{arb,erb,html,rb}",
    "./app/views/admin/**/*.{arb,erb,html,rb}",
    "./app/js/**/*.{js,jsx}",
    "./app/views/**/*.{erb,html}"
  ],
  darkMode: "selector",
  plugins: [activeAdminPlugin],
  safelist: [
    // Tom Select classes
    'tom-select-input',
    { pattern: /^ts-/ },
    // Other ActiveAdmin dynamic classes
    'panel-collapsed',
    'status-tag',
    // Add your custom classes here
  ]
};
```

### 6. Create Rake Task for CSS Building (lib/tasks/active_admin.rake)

```ruby
namespace :active_admin do
  desc "Build Active Admin Tailwind stylesheets"
  task build: :environment do
    command = [
      "npx", "tailwindcss",
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-c", Rails.root.join("tailwind-active_admin.config.js").to_s,
      "-m"
    ]

    puts "Building Active Admin CSS..."
    system(*command, exception: true)
  end

  desc "Watch Active Admin Tailwind stylesheets"
  task watch: :environment do
    command = [
      "npx", "tailwindcss",
      "--watch",
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-c", Rails.root.join("tailwind-active_admin.config.js").to_s,
      "-m"
    ]

    puts "Watching Active Admin CSS..."
    system(*command)
  end
end

Rake::Task["assets:precompile"].enhance(["active_admin:build"]) if Rake::Task.task_defined?("assets:precompile")
```

### 7. Update package.json Scripts

```json
{
  "scripts": {
    "build:js": "node esbuild.config.js",
    "build:css": "bundle exec rake active_admin:build",
    "build": "npm run build:js && npm run build:css",
    "watch:js": "node esbuild.config.js --watch",
    "watch:css": "bundle exec rake active_admin:watch",
    "dev": "npm run watch:js & npm run watch:css"
  }
}
```

## Migration Cleanup

### Files to Remove
- `inject-jquery.js` - No longer needed
- Any Select2-specific CSS files
- jQuery-specific initialization code

### Update Initializers
```ruby
# config/initializers/activeadmin_tom_select.rb (rename from activeadmin_searchable_select.rb)
require 'activeadmin-tom_select' if defined?(ActiveAdmin)
```

### Remove jQuery References
- Remove jQuery from package.json
- Remove inject-jquery.js from esbuild config
- Update any custom JavaScript to use vanilla JS instead of jQuery

## Usage in ActiveAdmin

The usage remains the same - no changes needed in your admin files:

```ruby
ActiveAdmin.register User do
  # In forms
  form do |f|
    f.input :company, as: :searchable_select
    f.input :role, as: :searchable_select,
            ajax: { resource: Role }
  end

  # In filters
  filter :company, as: :searchable_select
  filter :created_by, as: :searchable_select,
         ajax: { resource: User }
end
```

## CSS Class Changes for Custom Styling

If you have custom CSS, update these selectors:

| Old (Select2) | New (Tom Select) |
|--------------|------------------|
| `.select2-container` | `.ts-wrapper` |
| `.select2-dropdown` | `.ts-dropdown` |
| `.select2-results__option` | `.ts-dropdown .option` |
| `.select2-selection` | `.ts-control` |
| `.select2-search__field` | `.ts-control input` |

## Troubleshooting

### Issue: Tom Select not initializing
**Solution**: Ensure that:
- `window.TomSelect` is defined in browser console
- `setupAutoInit()` is called after importing
- No JavaScript errors in console

### Issue: Styles not loading
**Solution**:
- Verify CSS imports are using @import syntax, not @tailwind
- Check that tom-select CSS is in node_modules
- Ensure Tailwind processes the CSS file

### Issue: "elements.forEach is not a function" error
**Solution**: The `initSearchableSelects` function expects a NodeList or array, not a jQuery object. Use:
```javascript
// Correct - vanilla JS
const elements = document.querySelectorAll('.searchable-select-input');

// Incorrect - jQuery object
const elements = $('.searchable-select-input');
```

### Issue: Build errors with missing files
**Solution**: Run `npm install` and `bundle install` to ensure all dependencies are installed

## Performance Improvements

After migration, you should see:
- **Reduced bundle size**: ~200KB smaller without jQuery
- **Faster initialization**: Tom Select is more performant
- **Better memory usage**: No jQuery overhead
- **Cleaner code**: Pure ES6 modules

## Complete Example Configuration

For a working example, here's the minimal setup:

**Gemfile:**
```ruby
gem 'activeadmin', '~> 4.0.0.beta'
gem 'activeadmin-tom_select'
```

**package.json:**
```json
{
  "dependencies": {
    "@activeadmin/activeadmin": "^4.0.0-beta16",
    "tom-select": "^2.4.3",
    "activeadmin-tom_select": "^4.1.0"
  }
}
```

**app/js/active_admin.js:**
```javascript
import "@activeadmin/activeadmin";
import TomSelect from 'tom-select';
import { setupAutoInit, initSearchableSelects } from 'activeadmin-tom_select';

window.TomSelect = TomSelect;
window.initSearchableSelects = initSearchableSelects;
setupAutoInit();
```

**app/assets/stylesheets/active_admin.tailwind.css:**
```css
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";
@import 'tom-select/dist/css/tom-select.css';
@import 'activeadmin-tom_select/src/tom-select-tailwind.css';
```

## Benefits Achieved

1. ✅ **No jQuery Required**: Completely removed jQuery dependency
2. ✅ **Modern JavaScript**: Using ES6 modules and vanilla JS
3. ✅ **Smaller Bundle**: Reduced JavaScript bundle by ~200KB
4. ✅ **Better Performance**: Faster initialization and runtime
5. ✅ **Future-Proof**: Tom Select is actively maintained
6. ✅ **ActiveAdmin 4 Ready**: Full compatibility with latest version

## Migration Checklist

- [ ] Update Gemfile with `activeadmin-tom_select`
- [ ] Run `bundle install`
- [ ] Update package.json dependencies
- [ ] Run `npm install`
- [ ] Update JavaScript imports in active_admin.js
- [ ] Update CSS to use @import syntax
- [ ] Create/update rake tasks for CSS building
- [ ] Update build scripts in package.json
- [ ] Remove jQuery and Select2 dependencies
- [ ] Test all searchable selects in development
- [ ] Update any custom CSS selectors
- [ ] Remove old initialization files
- [ ] Deploy and test in production