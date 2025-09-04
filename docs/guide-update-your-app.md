# Migration Guide: Updating to rs-activeadmin-searchable_select

This guide will help you migrate from the original `activeadmin-searchable_select` gem to our forked and updated version `rs-activeadmin-searchable_select`.

## Quick Start (New Installation)

For new installations without a previous version:

```bash
# Add to Gemfile
echo "gem 'rs-activeadmin-searchable_select', '~> 4.0.5'" >> Gemfile
bundle install

# Install NPM packages
npm install @rocket-sensei/activeadmin-searchable_select jquery select2

# Then follow Step 3 and onward below
```

## Why Update?

Our fork provides:
- ✅ Full ActiveAdmin 4.0 support
- ✅ Rails 8 and Propshaft compatibility  
- ✅ Modern JavaScript bundler support (esbuild/webpack/importmap)
- ✅ Proper NPM package distribution under @rocket-sensei scope
- ✅ Fixed production build issues with select2
- ✅ Improved test suite with static ActiveAdmin registrations
- ✅ Active maintenance and support

## What's New in Version 4.0.5

- 🚀 **SonarQube Integration**: Full code quality analysis with 98% test coverage
- 📊 **SimpleCov JSON Reporting**: Coverage reports now use JSON format for better compatibility
- 🔧 **CI/CD Improvements**: Consolidated GitHub Actions workflow with SonarQube scanning
- 🧹 **Code Quality**: Reduced code duplication and improved maintainability
- 📦 **Synchronized Versioning**: Ruby gem and NPM package now share the same version number

## Migration Steps

### Step 1: Update your Gemfile

Replace the old gem with our fork:

```ruby
# Remove this:
# gem 'activeadmin-searchable_select'

# Add this:
gem 'rs-activeadmin-searchable_select', '~> 4.0.5'

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
npm uninstall @codevise/activeadmin-searchable_select

# Install new packages
npm install @rocket-sensei/activeadmin-searchable_select jquery select2
```

### Step 3: Update JavaScript Imports

Update your `app/javascript/active_admin.js`:

#### Option A: Auto-initialization (Recommended)

```javascript
import "@activeadmin/activeadmin";
import $ from 'jquery';
import select2 from 'select2';

// Critical: Initialize select2 on jQuery (fixes production builds)
select2($);
window.$ = window.jQuery = $;

// Import and auto-initialize searchable selects
import { setupAutoInit } from '@rocket-sensei/activeadmin-searchable_select';
setupAutoInit();
```

#### Option B: Manual initialization

```javascript
import "@activeadmin/activeadmin";
import $ from 'jquery';
import select2 from 'select2';

// Critical: Initialize select2 on jQuery (fixes production builds)
select2($);
window.$ = window.jQuery = $;

// Import the initialization function
import { initSearchableSelects } from '@rocket-sensei/activeadmin-searchable_select';

// Initialize manually when needed
$(document).ready(function() {
  initSearchableSelects($('.searchable-select-input'));
});
```

### Step 4: Add Select2 CSS

Add to your ActiveAdmin stylesheet (`app/assets/stylesheets/active_admin.css` or `.scss`):

```css
/* Import Select2 styles */
@import url('https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css');

/* Optional: Custom styling for searchable selects */
.searchable-select-input {
  width: 100%;
}

/* Fix for ActiveAdmin form layout */
.select2-container {
  min-width: 50%;
}
```

### Step 5: For Importmap Users

If you're using importmap instead of esbuild, add to `config/importmap.rb`:

```ruby
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
pin "select2", to: "https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.full.js"
pin "@rocket-sensei/activeadmin-searchable_select", to: "@rocket-sensei--activeadmin-searchable_select.js"
```

And update your `app/javascript/active_admin.js`:

```javascript
import "@activeadmin/activeadmin";
import jquery from "jquery";
import select2 from "select2";

// Make jQuery available globally
window.$ = window.jQuery = jquery;

// Initialize select2
select2(jquery);

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

### "select2 is not a function" Error

This usually happens in production when select2 isn't properly initialized. Ensure:

1. jQuery is loaded before select2
2. `select2($)` is called to initialize it on jQuery
3. jQuery is made globally available with `window.$ = window.jQuery = $`

### Styles Not Loading

1. Verify the Select2 CSS import is in your stylesheet
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

1. **NPM Scope**: Package is now `@rocket-sensei/activeadmin-searchable_select`
2. **Gem Name**: Gem is now `rs-activeadmin-searchable_select`
3. **Better Production Support**: Fixed select2 initialization issues
4. **Rails 8 Ready**: Full support for Propshaft and modern Rails
5. **Improved Tests**: Static ActiveAdmin registrations for better test isolation

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