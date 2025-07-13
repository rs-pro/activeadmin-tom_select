# Setting up ActiveAdmin 4 with Searchable Select

This guide documents how to set up a working ActiveAdmin 4 application with proper Tailwind CSS styling and the searchable_select gem.

## Key Requirements

1. **ActiveAdmin 4.x** (currently in beta)
2. **Tailwind CSS v3** (NOT v4) - ActiveAdmin's plugin is not compatible with Tailwind v4
3. **Node.js and npm** for managing JavaScript dependencies

## Step-by-Step Setup

### 1. Create a new Rails application

```bash
rails new demo-app --skip-test
cd demo-app
```

### 2. Add required gems to Gemfile

```ruby
# Admin interface
gem "activeadmin", "4.0.0.beta15"  # or latest beta
gem "devise"
gem "tailwindcss-rails"
gem "activeadmin-searchable_select", path: ".."  # or from rubygems
```

### 3. Install gems and ActiveAdmin

```bash
bundle install
rails generate active_admin:install
rails db:create db:migrate db:seed
```

### 4. Set up Tailwind CSS v3 (Critical!)

ActiveAdmin 4 uses a Tailwind plugin that requires Tailwind v3. The tailwindcss-rails gem might install v4, which is incompatible.

Create `package.json`:
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

Install npm dependencies:
```bash
npm install
```

### 5. Create Tailwind build task

Create `lib/tasks/active_admin.rake`:
```ruby
namespace :active_admin do
  desc "Build Active Admin Tailwind stylesheets"
  task build: :environment do
    command = [
      Rails.root.join("bin/tailwindcss").to_s,
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-c", Rails.root.join("tailwind-active_admin.config.js").to_s,
      "-m"
    ]
    puts command.join(" ")
    system(*command, exception: true)
  end
end

Rake::Task["assets:precompile"].enhance(["active_admin:build"])
```

### 6. Build CSS with Tailwind v3

```bash
# Create builds directory
mkdir -p app/assets/builds

# Use npx to run Tailwind v3
npx tailwindcss -i app/assets/stylesheets/active_admin.css \
  -o app/assets/builds/active_admin.css \
  -c tailwind-active_admin.config.js -m
```

### 7. Configure Select2 for searchable_select

Add to `config/importmap.rb`:
```ruby
# ActiveAdmin Searchable Select
pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"
pin "select2", to: "https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"
pin "active_admin/searchable_select", to: "active_admin/searchable_select.js"
```

Add Select2 CSS to `app/assets/stylesheets/active_admin.css`:
```css
@import url('https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css');

@tailwind base;
@tailwind components;
@tailwind utilities;
```

### 8. Set up models with Ransack 4 compatibility

```ruby
class User < ApplicationRecord
  has_many :posts
  
  def display_name
    "#{name} (#{email})"
  end
  
  def self.ransackable_attributes(auth_object = nil)
    ["name", "email", "department"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["posts"]
  end
end
```

### 9. Create ActiveAdmin resources

```ruby
ActiveAdmin.register User do
  permit_params :name, :email, :department
  
  searchable_select_options(scope: User, text_attribute: :display_name)
end

ActiveAdmin.register Post do
  permit_params :title, :content, :user_id
  
  form do |f|
    f.inputs do
      f.input :title
      f.input :content
      f.input :user, as: :searchable_select, ajax: true
    end
    f.actions
  end
end
```

## Common Issues and Solutions

### CSS Not Loading

1. **Wrong Tailwind version**: ActiveAdmin 4's plugin requires Tailwind v3, not v4
   - Check with: `npx tailwindcss --version`
   - Should show v3.x.x, not v4.x.x

2. **Missing npm dependencies**: The `@activeadmin/activeadmin` npm package must be installed
   - Run: `npm install @activeadmin/activeadmin`

3. **Wrong config format**: Use CommonJS format for Tailwind config with v3:
   ```javascript
   const { execSync } = require('child_process');
   module.exports = {
     plugins: [
       require('@activeadmin/activeadmin/plugin')
     ]
   }
   ```

### Select2 Not Initializing

1. Ensure jQuery and Select2 are loaded via importmap
2. Check that `active_admin/searchable_select.js` is being served correctly
3. Verify the gem's engine is properly mounted

## JavaScript Setup Issues

The searchable_select JavaScript integration with ActiveAdmin 4's new importmap system needs work. The gem's engine tries to register the JavaScript with importmap, but ActiveAdmin 4 uses its own importmap instance that requires different integration.

### Current Status

1. **CSS**: Working correctly with Tailwind v3
2. **Ruby/Rails**: Gem loads and renders searchable select inputs
3. **JavaScript**: Not automatically initialized (requires manual setup)

## Verification

1. Start the Rails server: `rails server`
2. Visit: `http://localhost:3000/admin`
3. Login with: `admin@example.com` / `password`
4. Check that:
   - Dark theme toggle works ✓
   - Tailwind styling is applied ✓
   - Select2 dropdowns are initialized on searchable_select fields ✗ (needs work)

## Next Steps

To fully integrate searchable_select with ActiveAdmin 4:

1. Update the gem's engine to properly integrate with ActiveAdmin's importmap
2. Ensure jQuery and Select2 are loaded in the correct order
3. Make sure the searchable_select.js module is imported and initialized
4. Add proper event listeners for Turbo/Stimulus compatibility