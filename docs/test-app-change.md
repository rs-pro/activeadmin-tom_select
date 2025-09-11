# Test App Migration from Combustion to Rails 8 (2025-09-11)

## Summary
Migrated the test environment from Combustion-based minimal app to a full Rails 8 application with Propshaft, Tom Select, and Tailwind CSS v3.

## Key Changes

### 1. Removed Combustion
- Backed up old `spec/internal` to `spec/internal.backup`
- Created new full Rails 8 app in `spec/internal`
- Removed all Combustion references from specs
- Fixed RSpec configuration to load Rails app directly

### 2. Rails 8 Test App Setup
```ruby
# Created with:
rails new spec/internal \
  --skip-action-cable \
  --skip-action-mailbox \
  --skip-action-text \
  --skip-active-storage \
  --skip-bootsnap \
  --skip-brakeman \
  --skip-ci \
  --skip-docker \
  --skip-git \
  --skip-hotwire \
  --skip-jbuilder \
  --skip-kamal \
  --skip-rubocop \
  --skip-solid \
  --skip-system-test \
  --skip-test \
  --skip-thruster \
  --css=tailwind \
  --javascript=esbuild
```

### 3. Asset Pipeline (Propshaft)
- Removed sassc-rails (using Tailwind only)
- Configured Propshaft for asset serving
- Built CSS outputs to `app/assets/builds/active_admin.css`
- Tom Select styles integrated via Tailwind build process

### 4. Tom Select Integration
- Migrated from Select2 to Tom Select
- Full Tailwind CSS styling for Tom Select components
- Styles located in `/src/tom-select-tailwind.css`
- Credits: Based on https://github.com/orchidjs/tom-select/discussions/693 by @LeZellus

### 5. Database Setup
```ruby
# spec/internal/db/schema.rb includes:
- users (with name field)
- admin_users (for Devise/ActiveAdmin)
- categories, posts, colors, rgb_colors
- tags, taggings (many-to-many)
- option_types, internal_tag_names (for tests)
```

### 6. Build Process
```bash
# CSS Build (Tailwind with Tom Select)
cd spec/internal
bundle exec rake active_admin:build

# JavaScript Build
npm run build

# Watch mode
bundle exec rake active_admin:watch  # CSS
npm run watch:js                     # JavaScript
```

### 7. Running the Test App
```bash
cd spec/internal
bundle exec rackup
# Available at http://localhost:9292
# Admin login: admin@example.com / password
```

### 8. Fixed Issues
- ✅ Removed duplicate config.ru from root
- ✅ Fixed empty schema.rb
- ✅ Added missing Devise gem
- ✅ Created missing models (AdminUser, Color, Tag, Tagging)
- ✅ Fixed seeds.rb to match schema
- ✅ Converted from Sprockets to Propshaft
- ✅ Downgraded Tailwind CSS from v4 to v3 for compatibility
- ✅ Fixed all RSpec/Capybara loading issues

### 9. File Structure
```
spec/internal/
├── app/
│   ├── admin/           # ActiveAdmin resources
│   ├── assets/
│   │   ├── builds/       # Built CSS/JS (Propshaft serves these)
│   │   └── stylesheets/
│   │       └── active_admin.tailwind.css
│   └── models/          # Test models
├── config/
│   ├── initializers/
│   │   ├── active_admin.rb
│   │   └── devise.rb
│   └── routes.rb
├── db/
│   ├── schema.rb        # Complete test schema
│   └── seeds.rb         # Test data
├── lib/
│   └── tasks/
│       └── active_admin.rake  # Build tasks
├── package.json         # Node dependencies
├── tailwind.config.js   # Tailwind configuration
├── Gemfile             # Ruby dependencies (Propshaft, no Sprockets)
└── config.ru           # Rack configuration
```

### 10. Dependencies
- Rails 8.0.2+
- ActiveAdmin 4.0.0.beta16
- Propshaft (not Sprockets)
- Tailwind CSS v3 (not v4)
- Tom Select 2.4.3
- esbuild for JavaScript
- cssbundling-rails for CSS

### 11. Testing
```bash
# Run all specs
bundle exec rspec

# Run specific spec
bundle exec rspec spec/features/form_input_spec.rb

# Tests now work with:
- No Combustion dependency
- Proper Rails 8 app loading
- ActiveAdmin integration
- Tom Select functionality
```

### 12. Documentation Updates
- Updated CLAUDE.md with new test app instructions
- Updated README.md with development/testing section
- Added `bundle exec rackup` instructions for manual testing

## Important Notes
- Always use Tailwind v3 (v4 has breaking changes)
- Tom Select base CSS is concatenated during build
- All imports use proper @import directives
- Test app is a full Rails app, not a minimal Combustion app
- Propshaft serves assets from app/assets/builds/