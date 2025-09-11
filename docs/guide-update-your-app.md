# Migration Guide: Updating to rs-activeadmin-searchable_select with Tom Select

This guide will help you migrate from the original `activeadmin-searchable_select` gem to our forked and updated version `rs-activeadmin-searchable_select`, which now uses Tom Select instead of Select2.

## Quick Start (New Installation)

For new installations without a previous version:

```bash
# Add to Gemfile
echo "gem 'rs-activeadmin-searchable_select', '~> 5.0.0'" >> Gemfile
bundle install

# Install NPM packages
npm install @rocket-sensei/activeadmin-searchable_select tom-select

# Then follow Step 3 and onward below
```

## Why Update?

Our fork provides:
- ✅ Full ActiveAdmin 4.0 support
- ✅ Rails 8 and Propshaft compatibility  
- ✅ Modern JavaScript bundler support (esbuild/webpack/importmap)
- ✅ **Tom Select** instead of Select2 (no jQuery dependency!)
- ✅ Virtual scroll for large datasets with pagination
- ✅ Proper NPM package distribution under @rocket-sensei scope
- ✅ Improved test suite with static ActiveAdmin registrations
- ✅ Active maintenance and support

## What's New in Version 5.0.0

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
# Remove this:
# gem 'activeadmin-searchable_select'

# Add this:
gem 'rs-activeadmin-searchable_select', '~> 5.0.0'

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
npm uninstall @codevise/activeadmin-searchable_select jquery select2

# Install new packages (Tom Select instead of Select2)
npm install @rocket-sensei/activeadmin-searchable_select tom-select
```

### Step 3: Update JavaScript Imports

Update your `app/javascript/active_admin.js`:

#### Option A: Auto-initialization (Recommended)

```javascript
import "@activeadmin/activeadmin";

// Import Tom Select (no jQuery required!)
import TomSelect from 'tom-select';
window.TomSelect = TomSelect;

// Import and auto-initialize searchable selects
import { setupAutoInit } from '@rocket-sensei/activeadmin-searchable_select';
setupAutoInit();
```

#### Option B: Manual initialization

```javascript
import "@activeadmin/activeadmin";

// Import Tom Select (no jQuery required!)
import TomSelect from 'tom-select';
window.TomSelect = TomSelect;

// Import the initialization function
import { initSearchableSelects } from '@rocket-sensei/activeadmin-searchable_select';

// Initialize manually when needed
document.addEventListener('DOMContentLoaded', function() {
  const selects = document.querySelectorAll('.searchable-select-input');
  initSearchableSelects(selects);
});
```

### Step 4: Add Tom Select CSS

Add to your ActiveAdmin stylesheet (`app/assets/stylesheets/active_admin.css` or `.scss`):

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
pin "@rocket-sensei/activeadmin-searchable_select", to: "@rocket-sensei--activeadmin-searchable_select.js"
```

And update your `app/javascript/active_admin.js`:

```javascript
import "@activeadmin/activeadmin";
import TomSelect from "tom-select";

// Make Tom Select available globally
window.TomSelect = TomSelect;

// Import and auto-initialize searchable selects
import { setupAutoInit } from "@rocket-sensei/activeadmin-searchable_select";
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

### Styles Not Loading

1. Verify the Tom Select CSS import is in your stylesheet
2. Check that your build process includes the stylesheets
3. Clear your browser cache and restart Rails server

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
2. **NPM Scope**: Package is now `@rocket-sensei/activeadmin-searchable_select`
3. **Gem Name**: Gem is now `rs-activeadmin-searchable_select`
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
https://github.com/glebtv/activeadmin-searchable_select/issues

## Contributing

We welcome contributions! Please:
1. Fork the repository
2. Create a feature branch
3. Write tests for your changes
4. Ensure all tests pass with `bundle exec rspec`
5. Submit a pull request

## License

This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).