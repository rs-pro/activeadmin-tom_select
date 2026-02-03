# Setting Up a Standalone ActiveAdmin 4 App (Tailwind v4)

This guide creates a new Rails app with ActiveAdmin 4.0.0.beta20, Tailwind CSS v4, and optional AA extension gems.

## 1. Create Rails App

```bash
rails new my_admin_app --css=tailwind --javascript=esbuild
cd my_admin_app
```

## 2. Gemfile

```ruby
# ActiveAdmin 4 beta
gem "activeadmin", "4.0.0.beta20"

# Required by ActiveAdmin 4
gem "importmap-rails", "~> 2.0"
gem "propshaft"

# Tailwind CLI (v4)
gem "tailwindcss-rails", "~> 4.4.0"
```

```bash
bundle install
```

## 3. Install ActiveAdmin

```bash
rails generate active_admin:install
rails db:create db:migrate db:seed
```

## 4. Install ActiveAdmin Assets

```bash
rails generate active_admin:assets
```

This creates:
- `app/assets/stylesheets/active_admin.css`
- `tailwind-active_admin.config.js` (ESM)

Rename to `.mjs` for Tailwind v4:

```bash
mv tailwind-active_admin.config.js tailwind-active_admin.config.mjs
```

## 5. Tailwind Input (ActiveAdmin)

Create or update the Tailwind input file:

```css
/* app/assets/stylesheets/active_admin.tailwind.css */
@import "tailwindcss";
@config "../../../tailwind-active_admin.config.mjs";
```

## 6. Build Tasks

```ruby
# lib/tasks/active_admin.rake
namespace :active_admin do
  desc "Build Active Admin Tailwind stylesheets"
  task build: :environment do
    command = [
      Rails.root.join("bin/tailwindcss").to_s,
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-m"
    ]

    system(*command, exception: true)
  end

  desc "Watch Active Admin Tailwind stylesheets"
  task watch: :environment do
    command = [
      Rails.root.join("bin/tailwindcss").to_s,
      "--watch",
      "-i", Rails.root.join("app/assets/stylesheets/active_admin.tailwind.css").to_s,
      "-o", Rails.root.join("app/assets/builds/active_admin.css").to_s,
      "-m"
    ]

    system(*command, exception: true)
  end
end

Rake::Task["assets:precompile"].enhance(["active_admin:build"])
```

## 7. JavaScript Entry

```javascript
// app/javascript/active_admin.js
import "@activeadmin/activeadmin";
```

## 8. Build Assets

```bash
bundle binstubs tailwindcss-ruby --force
npm install @activeadmin/activeadmin@^4.0.0-beta20
npm run build
```

## 9. Start Server

```bash
rails server
```

Visit http://localhost:3000/admin

## ActiveAdmin 4.0.0.beta20 Notes (from upgrade guide)

**Version Requirements:**
- Rails 7.2+ (Rails 7.0 and 7.1 are no longer supported)
- Ruby 3.2+ (Ruby 3.0 and 3.1 are no longer supported)

**Breaking Changes from earlier v4 betas:**
- `_site_header.html.erb` container class changed from `sticky` to `fixed`.
- `active_admin.html.erb` adds the `pt-16` utility class.
- Tailwind v4 requires `@import "tailwindcss"` + `@config`.
- jQuery and jQuery UI removed; `columns` and `tabs` components removed.
- Replace `default_main_content` with `render "show_default"`.
- Replace `as: :datepicker` with `as: :date_picker`.
- Replace `active_admin_comments` with `active_admin_comments_for(resource)`.
- Replace `attributes_table` with `attributes_table_for(resource)` in sidebars.

**New in beta20:**
- Parent menu item linking support
- Improved comments pagination styling
- Better vertical spacing for has-many forms
- Pointer cursor restored on eligible buttons
- Various accessibility improvements
