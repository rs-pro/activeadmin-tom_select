# ActiveAdmin Searchable Select - Claude Code Guide

## Overview

This repository contains the `activeadmin-searchable_select` Ruby gem that adds searchable select functionality to ActiveAdmin interfaces using Select2. The gem is currently being updated to support ActiveAdmin 4.0, which introduces significant frontend changes including Tailwind CSS.

## Project Structure

```
activeadmin-searchable_select/
├── app/
│   ├── assets/
│   │   ├── javascripts/           # Legacy Sprockets JS
│   │   └── stylesheets/           # Legacy and Tailwind CSS
│   └── javascript/                # Modern ES modules for ActiveAdmin 4
├── lib/
│   └── activeadmin/
│       └── searchable_select/
│           ├── engine.rb          # Rails engine configuration
│           ├── version.rb         # Gem version (currently 2.0.0.dev)
│           └── config.rb          # Configuration options
├── spec/                          # RSpec test suite
├── demo-app/                      # Demo Rails app for testing
├── gemfiles/                      # Appraisal gemfiles for testing
└── activeadmin-searchable_select.gemspec
```

## Key Technical Details

### ActiveAdmin 4.0 Requirements
- **Version**: Currently in beta (4.0.0.beta15 as of testing)
- **CSS Framework**: Tailwind CSS v3 (NOT v4 - this is critical!)
- **JavaScript**: Uses Importmap-rails for module loading
- **NPM Package**: Requires `@activeadmin/activeadmin` for Tailwind plugin
- **Authentication**: Requires Devise gem

### JavaScript Architecture
- Legacy: Sprockets-based (app/assets/javascripts/)
- Modern: ES modules with Importmap (app/javascript/)
- Select2 integration via jQuery
- Initialization hooks into ActiveAdmin's lifecycle

### CSS Architecture
- Legacy: SCSS files for Sprockets
- Modern: Tailwind CSS with ActiveAdmin's custom configuration
- Must use ActiveAdmin's Tailwind plugin for proper styling

## Working with Demo App

### Creating a Fresh Demo App
```bash
cd demo-app
rails new . --force
bundle add activeadmin -v "4.0.0.beta15"
bundle add devise
rails generate devise:install
rails generate devise User
rails generate active_admin:install
rails db:migrate
```

### Setting Up Tailwind CSS
1. Create package.json:
```json
{
  "name": "demo-app",
  "private": true,
  "dependencies": {
    "@activeadmin/activeadmin": "^4.0.0-beta15",
    "tailwindcss": "^3.4.0"
  }
}
```

2. Install dependencies:
```bash
npm install
```

3. Create rake task for building CSS (lib/tasks/active_admin.rake):
```ruby
namespace :active_admin do
  desc "Build Active Admin Tailwind stylesheets"
  task build: :environment do
    command = [
      "npx", "tailwindcss",
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-c", Rails.root.join("tailwind-active_admin.config.js").to_s,
      "-m"
    ]
    system(*command, exception: true)
  end
end
```

4. Build CSS:
```bash
rails active_admin:build
```

### Testing with Chrome Tool
Use the Chrome MCP tool to verify CSS is loading correctly:
```
mcp__chrome__browser_navigate(url: "http://localhost:3000/admin")
mcp__chrome__browser_screenshot()
```

## Common Issues and Solutions

### Issue: Tailwind CSS Not Loading
**Symptoms**: Minimal CSS, no dark theme, broken layout
**Solution**: 
1. Ensure using Tailwind v3, not v4
2. Install @activeadmin/activeadmin npm package
3. Use npx to run the correct Tailwind version
4. Check tailwind-active_admin.config.js includes the plugin

### Issue: Sprockets Manifest Error
**Error**: "link_directory argument must be a directory"
**Solution**: Create proper manifest.js with only necessary directives

### Issue: Select2 Not Initializing
**Symptoms**: Regular select boxes instead of searchable ones
**Cause**: JavaScript module not properly integrated with Importmap
**Solution**: Ensure proper initialization in app/javascript/active_admin/searchable_select.js

## Development Workflow

### Running Tests
```bash
bundle exec rspec
# Or with appraisals for different versions
appraisal rspec
```

### Linting
```bash
bundle exec rubocop
rails typecheck  # If available
```

### Version Compatibility
- ActiveAdmin 4.x (beta)
- Rails 7.x and 8.x
- Ruby 3.x
- Select2 4.x
- jQuery (provided by ActiveAdmin)

## Key Files to Understand

1. **activeadmin-searchable_select.gemspec**: Gem dependencies and metadata
2. **lib/activeadmin/searchable_select/engine.rb**: Rails engine setup
3. **app/javascript/active_admin/searchable_select.js**: Main JS initialization
4. **app/assets/stylesheets/active_admin/searchable_select_tailwind.css**: Tailwind styles

## Testing Searchable Select

Create a test model and ActiveAdmin resource:
```ruby
# In demo app
rails generate model Category name:string
rails db:migrate

# app/admin/categories.rb
ActiveAdmin.register Category do
  permit_params :name
  
  searchable_select_options(
    scope: Category.all,
    text_attribute: :name
  )
  
  index do
    selectable_column
    id_column
    column :name
    actions
  end
  
  filter :name, as: :searchable_select, ajax: true
  
  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end
end
```

## Important Notes

1. **Tailwind Version**: ActiveAdmin 4's Tailwind plugin is incompatible with Tailwind v4. Always use v3.
2. **JavaScript Loading**: The gem needs to properly integrate with ActiveAdmin's Importmap setup for JS to work.
3. **CSS Building**: Use the custom rake task with npx to ensure correct Tailwind version is used.
4. **Testing**: Always verify with browser testing using Chrome tool to ensure CSS and JS are working.

## Reference Implementation
See `/data/rslogin_ui/app/js/active_admin.js` for a working ActiveAdmin 4 JavaScript implementation that can be used as reference.

## Current Status
- ✅ Gem updated to support ActiveAdmin 4 dependency
- ✅ Modern JavaScript module created
- ✅ Tailwind CSS styles added
- ✅ Demo app successfully shows ActiveAdmin with Tailwind styling
- ❌ Select2 initialization needs fixing for Importmap integration
- ❌ Full browser testing integration pending