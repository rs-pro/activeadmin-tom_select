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

#### Option A: Using Tailwind CSS (Recommended for ActiveAdmin 4)

1. First, ensure your `package.json` includes the necessary build scripts:

```json
{
  "scripts": {
    "build:js": "esbuild app/javascript/*.* --bundle --sourcemap --format=esm --outdir=app/assets/builds --public-path=/assets",
    "build:css": "tailwindcss -i ./app/assets/stylesheets/active_admin.tailwind.css -o ./app/assets/builds/active_admin.css --minify"
  }
}
```

2. Add the Tom Select Tailwind styles to your `app/assets/stylesheets/active_admin.tailwind.css`:

```css
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";

/* Import Tom Select Tailwind styles from the package */
@import "activeadmin-tom_select/src/tom-select-tailwind.css";
```

3. Create a rake task for building CSS with Tailwind. Add to `lib/tasks/active_admin.rake`:

```ruby
namespace :active_admin do
  desc 'Build Active Admin Tailwind stylesheets'
  task :build do
    require 'fileutils'

    root = Rails.root

    # Ensure builds directory exists
    FileUtils.mkdir_p(File.join(root, 'app/assets/builds'))

    # Build with Tailwind CLI
    command = [
      'npx', 'tailwindcss',
      '-i', File.join(root, 'app/assets/stylesheets/active_admin.tailwind.css'),
      '-o', File.join(root, 'app/assets/builds/active_admin.css'),
      '-c', File.join(root, 'tailwind.config.js'),
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

4. Build your CSS:

```bash
# One-time build
bundle exec rake active_admin:build

# Or use npm script
npm run build:css

# For development with watch mode
bundle exec rake active_admin:watch
```

#### Option B: Using Regular CSS (without Tailwind)

If you're not using Tailwind CSS, add to your ActiveAdmin stylesheet (`app/assets/stylesheets/active_admin.css` or `.scss`):

```css
/* Import Tom Select styles */
@import 'tom-select/dist/css/tom-select.css';

/* Or if using CDN: */
@import url('https://cdn.jsdelivr.net/npm/tom-select@2.4.3/dist/css/tom-select.css');

/* Optional: Custom styling for searchable selects */
.searchable-select-input {
  width: 100%;
}

/* Fix for ActiveAdmin form layout */
.ts-wrapper {
  min-width: 50%;
}
```

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

#### For Tailwind CSS Users (ActiveAdmin 4):

1. **Missing Tailwind Build Process**: Ensure you have the rake task for building CSS (see Step 4 above)

2. **Check the Import Path**: The Tom Select styles should be imported from the package:
   ```css
   @import "activeadmin-tom_select/src/tom-select-tailwind.css";
   ```

3. **Build the CSS**: Run the build command:
   ```bash
   bundle exec rake active_admin:build
   # or
   npm run build:css
   ```

4. **Verify the Output**: Check that `app/assets/builds/active_admin.css` exists and contains Tom Select styles

5. **Include in Layout**: Ensure your ActiveAdmin layout includes the built CSS:
   ```erb
   <%= stylesheet_link_tag "active_admin", "data-turbo-track": "reload" %>
   ```

#### For Non-Tailwind Users:

1. Verify the Tom Select CSS import is in your stylesheet
2. Check that your build process includes the stylesheets
3. Clear your browser cache and restart Rails server

#### Common CSS Issues:

- **Dropdown not styled**: Missing Tom Select CSS - check import paths
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
2. **NPM Package**: Package is now `activeadmin-tom_select`
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
1. Check that all JavaScript packages are installed
2. Verify your bundler configuration
3. Clear browser cache and Rails tmp/cache
4. Check browser console for errors

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