# Migration Guide: ActiveAdmin Tom Select

This guide will help you migrate from the original `activeadmin-searchable_select` gem (or its fork) to the new `activeadmin-tom_select` gem, which uses Tom Select instead of Select2.

## Quick Start (New Installation)

For new installations without a previous version:

```bash
# Add to Gemfile
echo "gem 'activeadmin-tom_select', '~> 4.1.0'" >> Gemfile
bundle install

# Install NPM packages
npm install activeadmin-tom_select tom-select

# Install PostCSS plugins (REQUIRED for CSS imports to work)
npm install postcss postcss-import postcss-nesting autoprefixer

# Then follow Step 3 and onward below
```

## Why Update?

Our fork provides:
- ✅ Full ActiveAdmin 4.0 support
- ✅ Rails 8 and Propshaft compatibility
- ✅ Modern JavaScript bundler support (esbuild/webpack/importmap)
- ✅ **Tom Select** instead of Select2 (no jQuery dependency!)
- ✅ Virtual scroll for large datasets with pagination
- ✅ Proper NPM package distribution as activeadmin-tom_select
- ✅ Improved test suite with static ActiveAdmin registrations
- ✅ Active maintenance and support

## What's New in Version 4.1.0

- 🎉 **Tom Select**: Migrated from Select2 to Tom Select - no jQuery dependency!
- 📜 **Virtual Scroll**: Automatic pagination for large datasets
- 🚀 **Better Performance**: Lighter bundle size without jQuery
- 🔧 **Rails 8 Ready**: Full compatibility with Propshaft and Rails 8
- 📊 **98% Test Coverage**: Comprehensive test suite with SimpleCov
- 📦 **Modern JavaScript**: ES6 modules, vanilla JavaScript

## Migration Steps

### Step 1: Update your Gemfile

Replace the old gem with our fork:

```ruby
# Remove these:
# gem 'activeadmin-searchable_select'
# gem 'rs-activeadmin-searchable_select'

# Add this:
gem 'activeadmin-tom_select', '~> 4.1.0'

# For Rails 7, also ensure you have Propshaft:
gem 'propshaft' # Rails 8 includes this by default
```

Then run:
```bash
bundle install
```

### Step 2: Update JavaScript Dependencies

Remove old packages and install the new ones:

```bash
# Remove old packages if present
npm uninstall @codevise/activeadmin-searchable_select activeadmin-searchable_select jquery select2

# Install new packages (Tom Select instead of Select2)
npm install activeadmin-tom_select tom-select

# CRITICAL: Install PostCSS plugins for CSS imports to work
npm install postcss postcss-import postcss-nesting autoprefixer
```

**Note:** The `activeadmin-tom_select` package includes both JavaScript and CSS files:
- JavaScript: Auto-initialization and helper functions
- CSS: Tailwind-optimized Tom Select styles at `activeadmin-tom_select/src/tom-select-tailwind.css`

### Step 3: Update JavaScript Imports

Update your `app/javascript/active_admin.js`:

#### Option A: Auto-initialization (Recommended)

```javascript
import "@activeadmin/activeadmin";

// Import Tom Select (no jQuery required!)
import TomSelect from 'tom-select';
window.TomSelect = TomSelect;

// Import and auto-initialize searchable selects
import { setupAutoInit } from 'activeadmin-tom_select';
setupAutoInit();
```

#### Option B: Manual initialization

```javascript
import "@activeadmin/activeadmin";

// Import Tom Select (no jQuery required!)
import TomSelect from 'tom-select';
window.TomSelect = TomSelect;

// Import the initialization function
import { initSearchableSelects } from 'activeadmin-tom_select';

// Initialize manually when needed
document.addEventListener('DOMContentLoaded', function() {
  const selects = document.querySelectorAll('.searchable-select-input');
  initSearchableSelects(selects);
});
```

### Step 4: Configure CSS Build Process (For Tailwind CSS with ActiveAdmin 4)

## ⚠️ CRITICAL CSS SETUP REQUIREMENTS

**IMPORTANT**: The CSS build process has very specific requirements that must be followed exactly:

1. **Input file MUST use `.tailwind.css` extension** (not `.css`)
2. **MUST have PostCSS configuration with `postcss-import` plugin**
3. **MUST NOT use CDN imports** - all CSS must be imported from npm packages
4. **The rake task MUST include the `--postcss` flag**

### Required Files Setup

#### 1. Create PostCSS Configuration (`postcss.config.js`)

```javascript
module.exports = {
  plugins: [
    require('postcss-import'),     // CRITICAL: Required for @import to work
    require('postcss-nesting'),     // Optional: For nested CSS
    require('autoprefixer'),        // Optional: For browser compatibility
  ],
}
```

#### 2. Create Tailwind Input File (`app/assets/stylesheets/active_admin.tailwind.css`)

```css
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

/* CRITICAL: Import Tom Select styles from npm package, NOT from CDN! */
@import "@rocket-sensei/activeadmin-tom_select/src/tom-select-tailwind.css";

/* Import any custom styles */
@import "./active_admin_custom.css";

/* Custom styling for searchable selects */
.searchable-select-input {
  width: 100%;
}

/* Fix for ActiveAdmin form layout */
.ts-wrapper {
  min-width: 50%;
}
```

#### 3. Create Rake Task (`lib/tasks/active_admin.rake`)

```ruby
namespace :active_admin do
  desc 'Build Active Admin Tailwind stylesheets'
  task :build do
    require 'fileutils'

    root = Rails.root

    # Ensure builds directory exists
    FileUtils.mkdir_p(File.join(root, 'app/assets/builds'))

    # Build with Tailwind CLI (CRITICAL: include --postcss flag!)
    command = [
      'npx', 'tailwindcss',
      '-i', File.join(root, 'app/assets/stylesheets/active_admin.tailwind.css'),
      '-o', File.join(root, 'app/assets/builds/active_admin.css'),
      '-c', File.join(root, 'tailwind.config.js'),
      '--postcss', File.join(root, 'postcss.config.js'),  # CRITICAL: Must specify PostCSS config
      '-m'
    ]

    system(*command, exception: true)

    puts 'Built Active Admin CSS with Tailwind'
  end

  desc 'Watch Active Admin Tailwind stylesheets'
  task :watch do
    root = Rails.root

    # Watch for changes
    command = [
      'npx', 'tailwindcss',
      '--watch',
      '-i', File.join(root, 'app/assets/stylesheets/active_admin.tailwind.css'),
      '-o', File.join(root, 'app/assets/builds/active_admin.css'),
      '-c', File.join(root, 'tailwind.config.js'),
      '--postcss', File.join(root, 'postcss.config.js'),  # CRITICAL: Must specify PostCSS config
      '-m'
    ]

    system(*command)
  end
end

# Enhance existing rake tasks
if Rake::Task.task_defined?('assets:precompile')
  Rake::Task['assets:precompile'].enhance(['active_admin:build'])
end
```

#### 4. Update package.json scripts

```json
{
  "scripts": {
    "build:js": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets",
    "build:css": "bundle exec rake active_admin:build",
    "build": "npm run build:js && npm run build:css",
    "watch:css": "bundle exec rake active_admin:watch"
  }
}
```

#### 5. Build your CSS

```bash
# One-time build
bundle exec rake active_admin:build

# Or use npm script
npm run build:css

# For development with watch mode
bundle exec rake active_admin:watch
# or
npm run watch:css
```

### Common Build Errors and Solutions

#### Tom Select CSS Not Included in Built File

**Symptoms**: The built CSS file doesn't contain any Tom Select styles (no `.ts-wrapper`, `.ts-control`, etc. classes)

**Causes and Solutions**:
1. **Using CDN imports**: CDN imports (`@import url('https://...')`) are NOT processed by Tailwind. You MUST import from npm packages.
2. **Wrong file extension**: Input file must be `.tailwind.css`, not `.css`
3. **Missing PostCSS config**: Without `postcss-import` plugin, `@import` statements won't work
4. **Missing `--postcss` flag**: The rake task must include `--postcss` flag

**How to verify CSS is included**:
```bash
# Check if Tom Select classes are in the built file
grep -c "ts-wrapper\|ts-control\|ts-dropdown" app/assets/builds/active_admin.css
# Should return a number > 0
```

### Option B: Using Regular CSS (without Tailwind) - NOT RECOMMENDED

⚠️ **WARNING**: Using CDN imports or regular CSS imports without a proper build process will likely result in missing styles when using Tailwind CSS build. We strongly recommend using the Tailwind setup above.

If you absolutely must use regular CSS without Tailwind, you'll need a different build process that can handle CSS imports, such as:
- Using Webpack with css-loader
- Using esbuild with CSS plugins
- Using a dedicated CSS bundler

### Step 5: For Importmap Users

If you're using importmap instead of esbuild, add to `config/importmap.rb`:

```ruby
pin "tom-select", to: "https://ga.jspm.io/npm:tom-select@2.4.3/dist/js/tom-select.complete.min.js"
pin "activeadmin-tom_select", to: "activeadmin-tom_select.js"
```

And update your `app/javascript/active_admin.js`:

```javascript
import "@activeadmin/activeadmin";
import TomSelect from "tom-select";

// Make Tom Select available globally
window.TomSelect = TomSelect;

// Import and auto-initialize searchable selects
import { setupAutoInit } from "activeadmin-tom_select";
setupAutoInit();
```

### Step 6: Update Your ActiveAdmin Resources

The API remains the same, but ensure your resources are configured correctly:

```ruby
ActiveAdmin.register Product do
  # For forms
  form do |f|
    f.inputs do
      f.input :category, as: :searchable_select, ajax: true
      f.input :tags, as: :searchable_select, ajax: true, multiple: true
    end
    f.actions
  end

  # For filters
  filter :category, as: :searchable_select, ajax: true
  filter :tags, as: :searchable_select, ajax: true, multiple: true
end

# Define searchable select options endpoint
ActiveAdmin.register Category do
  searchable_select_options(
    scope: Category.all,
    text_attribute: :name
  )
end
```

## Troubleshooting

### "TomSelect is not defined" Error

This usually happens when Tom Select isn't properly imported. Ensure:

1. Tom Select is imported in your JavaScript file
2. `window.TomSelect = TomSelect` is set to make it globally available
3. The NPM package is installed: `npm install tom-select`

### Styles Not Loading / CSS Missing

This is a common issue when migrating to ActiveAdmin 4 with Tailwind CSS. Here's how to fix it:

#### Checklist for Tailwind CSS Users:

1. ✅ **File Extension**: Is your input file named `active_admin.tailwind.css` (NOT `active_admin.css`)?
2. ✅ **PostCSS Config**: Do you have `postcss.config.js` with `postcss-import` plugin?
3. ✅ **NPM Packages**: Are PostCSS plugins installed? (`npm install postcss postcss-import`)
4. ✅ **No CDN Imports**: Are you importing from npm packages, not CDN URLs?
5. ✅ **Rake Task**: Does your rake task include `--postcss` flag?
6. ✅ **Build Output**: Does `app/assets/builds/active_admin.css` contain Tom Select classes?

Run this diagnostic command:
```bash
# Check if everything is set up correctly
echo "Checking setup..."
[ -f postcss.config.js ] && echo "✅ PostCSS config exists" || echo "❌ Missing postcss.config.js"
[ -f app/assets/stylesheets/active_admin.tailwind.css ] && echo "✅ Tailwind CSS file exists" || echo "❌ Missing active_admin.tailwind.css"
grep -q "postcss-import" postcss.config.js && echo "✅ postcss-import configured" || echo "❌ postcss-import not in config"
grep -q "@rocket-sensei/activeadmin-tom_select" app/assets/stylesheets/active_admin.tailwind.css && echo "✅ Tom Select import found" || echo "❌ Tom Select import missing"
grep -q "ts-wrapper" app/assets/builds/active_admin.css 2>/dev/null && echo "✅ Tom Select CSS in built file" || echo "❌ Tom Select CSS NOT in built file"
```

#### Common CSS Issues:

- **Dropdown not styled**: Missing Tom Select CSS - verify all setup steps above
- **Width issues**: Add `.ts-wrapper { min-width: 50%; }` to your styles
- **Z-index problems**: Tom Select dropdowns may need higher z-index in some layouts
- **Missing icons**: Ensure the Tom Select CSS is fully loaded

### Ajax Options Not Loading

1. Ensure `searchable_select_options` is defined in the target resource
2. Check browser console for any JavaScript errors
3. Verify the AJAX URLs are correct in the network tab

### Multiple Select Not Working

Ensure you've added `multiple: true` to both the input and the corresponding association:

```ruby
# In your model
has_many :tags

# In your ActiveAdmin resource
f.input :tags, as: :searchable_select, ajax: true, multiple: true
```

## Version Compatibility

- **Ruby**: >= 3.0
- **Rails**: >= 7.0 (optimized for Rails 8)
- **ActiveAdmin**: ~> 4.0.0.beta
- **Node.js**: >= 18.0

## Differences from Original Gem

1. **Tom Select instead of Select2**: No jQuery dependency required!
2. **NPM Package**: Package is now `activeadmin-tom_select` or `@rocket-sensei/activeadmin-tom_select`
3. **Gem Name**: Gem is now `activeadmin-tom_select`
4. **Virtual Scroll**: Automatic pagination for large datasets
5. **Rails 8 Ready**: Full support for Propshaft and modern Rails
6. **Better Performance**: Smaller bundle size without jQuery
7. **Modern JavaScript**: ES6 modules and vanilla JavaScript

## Migration Notes for Select2 Users

If you're migrating from a Select2-based version to this Tom Select version:

### CSS Class Changes
| Select2 Class | Tom Select Class |
|---------------|------------------|
| `.select2-container` | `.ts-wrapper` |
| `.select2-dropdown` | `.ts-dropdown` |
| `.select2-selection` | `.ts-control` |
| `.select2-results` | `.ts-dropdown-content` |
| `.select2-search__field` | `.ts-control input` |

### JavaScript API Changes
- No jQuery dependency required
- Tom Select instances are attached directly to the DOM element: `element.tomselect`
- Options are configured differently (see Tom Select documentation)

### Features
- Virtual scroll is automatically enabled for AJAX-loaded options
- Clear button is included by default (can be disabled with `clearable: false`)
- Pagination now uses 1-based indexing (page 1 is the first page)

## Need Help?

If you encounter issues:
1. Run the diagnostic command above to check your setup
2. Verify all npm packages are installed
3. Check that PostCSS config is correct
4. Ensure no CDN imports are being used
5. Clear browser cache and Rails tmp/cache
6. Check browser console for errors

For bug reports or questions, please visit:
https://github.com/rs-pro/activeadmin-tom_select/issues

## Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Write tests for your changes
4. Ensure all tests pass with `bundle exec rspec`
5. Submit a pull request

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).